#include <cassert>
#include <string>
#include <cstring>
#include <cstdio>
#include <cassert>
#include <string>
#include <vector>
#include <cstring>
#include <iostream>
#include <cstring>

#include "./llam.cpp/llmodel.h"

std::string answer = "";
LLModel::PromptContext prompt_context;
LLModel* model = nullptr;
bool _stopFlag = false;

// --------- Struct for Parameters --------------
struct llm_params {
    std::string model = "models/model.gguf";
    std::string backend = "cpu";
    bool stream = true;
    std::string prompt_template = "### Human:\n%1\n\n### Assistant:\n";
    std::string system_prompt = "### System:\nYou are an AI assistant who gives a quality response to whatever humans ask of you.\n\n";
    double temperature = 0.7;
    int top_k = 40;
    double top_p = 0.4;
    double min_p = 0.0;
    double repeat_penalty = 1.18;
    int prompt_batch_size = 128;
    int max_tokens = 4096;
    int repeat_penalty_tokens = 64;
    int context_length = 2048;
    int number_of_gpu_layers = 80;
};

// --------- Argument Parser -------------------
void llm_print_usage(const llm_params& p, const char* progname) {
    std::cout <<
        std::string("Usage: %1 [options]").arg(progname) << "\n\n"
                    "Options:\n"
                    "  --stream [true|false]              Enable/disable streaming output (default: true)\n"
                    "  --prompt-template <string>         Prompt template with %1 as input slot\n"
                    "  --system-prompt <string>           System prompt text\n"
                    "  --temperature <float>              Temperature (default: 0.7)\n"
                    "  --top-k <int>                      Top-K sampling (default: 40)\n"
                    "  --top-p <float>                    Top-P sampling (default: 0.4)\n"
                    "  --min-p <float>                    Minimum probability (default: 0.0)\n"
                    "  --repeat-penalty <float>           Repeat penalty (default: 1.18)\n"
                    "  --prompt-batch-size <int>          Prompt batch size (default: 128)\n"
                    "  --max-tokens <int>                 Max tokens (default: 4096)\n"
                    "  --repeat-penalty-tokens <int>      Number of tokens for repetition penalty (default: 64)\n"
                    "  --context-length <int>             Context length (default: 2048)\n"
                    "  --gpu-layers <int>                 Number of GPU layers (default: 80)\n";
}

bool llm_parse_args(int argc, char* argv[], llm_params& params) {
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--help") {
            llm_print_usage(params, argv[0]);
            exit(0);
        } else if (arg == "--model") {
            params.model = argv[++i];
        } else if (arg == "--stream") {
            params.backend = argv[++i];
        } else if (arg == "--stream") {
            params.stream = std::string(argv[++i]).toLower() == "true";
        } else if (arg == "--prompt-template") {
            params.prompt_template = argv[++i];
        } else if (arg == "--system-prompt") {
            params.system_prompt = argv[++i];
        } else if (arg == "--temperature") {
            params.temperature = std::string(argv[++i]).toDouble();
        } else if (arg == "--top-k") {
            params.top_k = std::string(argv[++i]).toInt();
        } else if (arg == "--top-p") {
            params.top_p = std::string(argv[++i]).toDouble();
        } else if (arg == "--min-p") {
            params.min_p = std::string(argv[++i]).toDouble();
        } else if (arg == "--repeat-penalty") {
            params.repeat_penalty = std::string(argv[++i]).toDouble();
        } else if (arg == "--prompt-batch-size") {
            params.prompt_batch_size = std::string(argv[++i]).toInt();
        } else if (arg == "--max-tokens") {
            params.max_tokens = std::string(argv[++i]).toInt();
        } else if (arg == "--repeat-penalty-tokens") {
            params.repeat_penalty_tokens = std::string(argv[++i]).toInt();
        } else if (arg == "--context-length") {
            params.context_length = std::string(argv[++i]).toInt();
        } else if (arg == "--gpu-layers") {
            params.number_of_gpu_layers = std::string(argv[++i]).toInt();
        } else {
            qWarning() << "Unknown argument:" << arg;
            llm_print_usage(params, argv[0]);
            exit(0);
        }
    }
    return true;
}

// --------- Response Handler ------------------
bool handleResponse(int32_t token, const std::string &response) {
    const char* responsechars = response.c_str();
    if (!(responsechars == nullptr || responsechars[0] == '\0')) {
        std::cout << responsechars << std::flush;
        answer += responsechars;
    }
    return !_stopFlag.load();
}


int main(int argc, char *argv[]) {
    llm_params params;

    if (!llm_parse_args(argc, argv, params))
        return 1;

    prompt_context.n_ctx = params.context_length;
    prompt_context.n_predict = params.max_tokens;

    model = LLModel::Implementation::construct(params.model, params.backend, prompt_context.n_ctx);
    if (!model) {
        qWarning() << "Failed to construct model.";
        return 1;
    }

#if defined(WIN32)
    if (params.backend == "cuda") {
        auto devices = LLModel::Implementation::availableGPUDevices();
        if (!devices.empty()) {
            size_t memoryRequired = devices[0].heapSize;
            const std::string& name = devices[0].name;
            auto filteredDevices = model->availableGPUDevices(memoryRequired);
            for (const auto& device : filteredDevices) {
                if (device.name == name && model->initializeGPUDevice(device.index)) {
                    break;
                }
            }
        }
    }
#endif

    if (!model->loadModel(params.model, prompt_context.n_ctx, params.number_of_gpu_layers)) {
        std::cout  << "Model loading unsuccessful!\n";
        return 1;
    } else {
        std::cout  << "Model loaded successfully!\n";
    }

    bool chatInProcess = true;

    while(chatInProcess){
        std::string line;
        std::getline(std::cin, line);

        std::string input;

        if (line == "__STOP__") {
            _stopFlag.store(true);
            continue;
        }else if (line == "__EXIT__") {
            break;
        }else if (line == "__PROMPT__") {
            std::getline(std::cin, input);
        }

        _stopFlag.store(false);
        answer.clear();

        auto prompt_callback = [](int32_t token_id) { return true;};
        auto response_callback = std::bind(&handleResponse, this, std::placeholders::_1, std::placeholders::_2);
        auto recalculate_callback = [](bool is_recalculating) {return is_recalculating;};

        model->prompt( input , params.prompt_template, prompt_callback, response_callback, recalculate_callback,prompt_context , false, nullptr);

        std::cout << "\n__DONE__\n" << std::flush;

    }

    return a.exec();
}
