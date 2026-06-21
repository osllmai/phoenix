#include "llama.h"

#include <atomic>
#include <cstring>
#include <iostream>
#include <string>
#include <vector>

#include "params.h"

namespace {

llama_model* g_model = nullptr;
llama_context* g_ctx = nullptr;
const llama_vocab* g_vocab = nullptr;
GenParams g_params;
std::atomic<bool> g_stop{false};

llama_sampler* build_sampler(const GenParams& p) {
    auto* s = llama_sampler_chain_init(llama_sampler_chain_default_params());
    llama_sampler_chain_add(s, llama_sampler_init_penalties(p.repeat_last_n, p.repeat_penalty, 0.0f, 0.0f));
    llama_sampler_chain_add(s, llama_sampler_init_top_k(p.top_k));
    llama_sampler_chain_add(s, llama_sampler_init_top_p(p.top_p, 1));
    llama_sampler_chain_add(s, llama_sampler_init_min_p(p.min_p, 1));
    llama_sampler_chain_add(s, llama_sampler_init_temp(p.temp));
    llama_sampler_chain_add(s, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));
    return s;
}

std::string generate(const std::string& prompt) {
    g_stop = false;
    auto* mem = llama_get_memory(g_ctx);
    const bool is_first = llama_memory_seq_pos_max(mem, 0) == -1;

    const int n_prompt = -llama_tokenize(g_vocab, prompt.c_str(), prompt.size(), nullptr, 0, is_first, true);
    std::vector<llama_token> toks(n_prompt);
    if (llama_tokenize(g_vocab, prompt.c_str(), prompt.size(), toks.data(), toks.size(), is_first, true) < 0) {
        std::cerr << "tokenize failed\n";
        return "";
    }

    llama_sampler* smpl = build_sampler(g_params);
    llama_batch batch = llama_batch_get_one(toks.data(), toks.size());
    llama_token id;
    std::string response;
    int generated = 0;

    while (!g_stop && generated < g_params.n_predict) {
        const int n_ctx = llama_n_ctx(g_ctx);
        const int n_used = llama_memory_seq_pos_max(mem, 0) + 1;
        if (n_used + batch.n_tokens > n_ctx) break;
        if (llama_decode(g_ctx, batch) != 0) break;

        id = llama_sampler_sample(smpl, g_ctx, -1);
        if (llama_vocab_is_eog(g_vocab, id)) break;

        char buf[256];
        const int n = llama_token_to_piece(g_vocab, id, buf, sizeof(buf), 0, true);
        if (n < 0) break;
        std::string piece(buf, n);
        if (g_params.stream) std::cout << piece << std::flush;
        response += piece;
        ++generated;
        batch = llama_batch_get_one(&id, 1);
    }

    llama_sampler_free(smpl);
    if (!g_params.stream) std::cout << response << std::flush;
    return response;
}

void run_loop() {
    const char* tmpl = llama_model_chat_template(g_model, nullptr);
    std::vector<llama_chat_message> messages;
    std::vector<char> formatted(llama_n_ctx(g_ctx));
    int prev_len = 0;

    std::cout << "__LoadingModel__Finished__\n" << std::flush;

    std::string command;
    while (std::getline(std::cin, command)) {
        if (command == "__EXIT__") break;

        if (command == "__PARAMS_SETTINGS__") {
            std::string line;
            while (std::getline(std::cin, line) && line != "__END_PARAMS_SETTINGS__") {
                apply_param(g_params, line);
            }
            continue;
        }

        if (command == "__PROMPT__") {
            std::string input, line;
            while (std::getline(std::cin, line) && line != "__END__") {
                input += line + "\n";
            }
            if (!input.empty() && input.back() == '\n') input.pop_back();

            if (messages.empty() && !g_params.system_prompt.empty()) {
                messages.push_back({"system", strdup(g_params.system_prompt.c_str())});
            }
            messages.push_back({"user", strdup(input.c_str())});

            std::string prompt = input;
            if (tmpl) {
                int n = llama_chat_apply_template(tmpl, messages.data(), messages.size(), true,
                                                  formatted.data(), formatted.size());
                if (n > (int)formatted.size()) {
                    formatted.resize(n);
                    n = llama_chat_apply_template(tmpl, messages.data(), messages.size(), true,
                                                  formatted.data(), formatted.size());
                }
                if (n >= 0) prompt.assign(formatted.begin() + prev_len, formatted.begin() + n);
            }

            std::string response = generate(prompt);
            messages.push_back({"assistant", strdup(response.c_str())});
            if (tmpl) {
                prev_len = llama_chat_apply_template(tmpl, messages.data(), messages.size(), false, nullptr, 0);
            }
            std::cout << "__DONE_PROMPTPROCESS__\n" << std::flush;
            continue;
        }

        if (command == "__STOP__") {
            g_stop = true;
            std::cout << "Prompt stopped.\n" << std::flush;
        }
    }
}

}  // namespace

int main(int argc, char* argv[]) {
    if (!parse_args(argc, argv, g_params)) return 1;

    llama_log_set([](ggml_log_level level, const char* text, void*) {
        if (level >= GGML_LOG_LEVEL_ERROR) std::cerr << text;
    }, nullptr);
    ggml_backend_load_all();

    llama_model_params mp = llama_model_default_params();
    mp.n_gpu_layers = g_params.n_gpu_layers;
    g_model = llama_model_load_from_file(g_params.model.c_str(), mp);
    if (!g_model) {
        std::cerr << "Model load failed completely.\n" << std::flush;
        return 1;
    }
    g_vocab = llama_model_get_vocab(g_model);

    llama_context_params cp = llama_context_default_params();
    cp.n_ctx = g_params.ctx_size;
    cp.n_batch = g_params.n_batch;
    g_ctx = llama_init_from_model(g_model, cp);
    if (!g_ctx) {
        std::cerr << "Context creation failed.\n" << std::flush;
        return 1;
    }

    run_loop();

    llama_free(g_ctx);
    llama_model_free(g_model);
    return 0;
}
