#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <cstdlib>

#include <gpt4all-backend/llmodel.h>

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

// --------- Global Variables -------------------
std::string answer = "";
// LLModel::PromptContext prompt_context;
LLModel* model = nullptr;
std::atomic<bool> _stopFlag = false;

// --------- Print Help Message -----------------
void llm_print_usage(const llm_params& p, const char* progname) {
    std::cout <<
        "Usage: " << progname << " [options]\n\n"
                                 "Options:\n"
                                 "  --model <path>                     Path to model file (default: models/model.gguf)\n"
                                 "  --backend <cpu|cuda|auto>          Backend to use (default: cpu)\n"
                                 "  --stream [true|false]              Enable streaming output (default: true)\n"
                                 "  --prompt-template <string>         Prompt template with %1 as input slot\n"
                                 "  --system-prompt <string>           System prompt text\n"
                                 "  --temperature <float>              Temperature (default: 0.7)\n"
                                 "  --top-k <int>                      Top-K sampling (default: 40)\n"
                                 "  --top-p <float>                    Top-P sampling (default: 0.4)\n"
                                 "  --min-p <float>                    Minimum probability (default: 0.0)\n"
                                 "  --repeat-penalty <float>           Repeat penalty (default: 1.18)\n"
                                 "  --prompt-batch-size <int>          Prompt batch size (default: 128)\n"
                                 "  --max-tokens <int>                 Max tokens (default: 4096)\n"
                                 "  --repeat-penalty-tokens <int>      Tokens for repetition penalty (default: 64)\n"
                                 "  --context-length <int>             Context length (default: 2048)\n"
                                 "  --gpu-layers <int>                 Number of GPU layers (default: 80)\n";
}

// --------- Argument Parser -------------------
bool llm_parse_args(int argc, char* argv[], llm_params& params) {
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];

        if (arg == "--help") {
            llm_print_usage(params, argv[0]);
            exit(0);
        } else if (arg == "--model") {
            params.model = argv[++i];
        } else if (arg == "--backend") {
            params.backend = argv[++i];
        } else if (arg == "--stream") {
            std::string val = argv[++i];
            std::transform(val.begin(), val.end(), val.begin(), ::tolower);
            params.stream = (val == "true");
        } else if (arg == "--prompt-template") {
            params.prompt_template = argv[++i];
        } else if (arg == "--system-prompt") {
            params.system_prompt = argv[++i];
        } else if (arg == "--temperature") {
            params.temperature = std::stod(argv[++i]);
        } else if (arg == "--top-k") {
            params.top_k = std::stoi(argv[++i]);
        } else if (arg == "--top-p") {
            params.top_p = std::stod(argv[++i]);
        } else if (arg == "--min-p") {
            params.min_p = std::stod(argv[++i]);
        } else if (arg == "--repeat-penalty") {
            params.repeat_penalty = std::stod(argv[++i]);
        } else if (arg == "--prompt-batch-size") {
            params.prompt_batch_size = std::stoi(argv[++i]);
        } else if (arg == "--max-tokens") {
            params.max_tokens = std::stoi(argv[++i]);
        } else if (arg == "--repeat-penalty-tokens") {
            params.repeat_penalty_tokens = std::stoi(argv[++i]);
        } else if (arg == "--context-length") {
            params.context_length = std::stoi(argv[++i]);
        } else if (arg == "--gpu-layers") {
            params.number_of_gpu_layers = std::stoi(argv[++i]);
        } else {
            std::cerr << "Unknown argument: " << arg << "\n";
            llm_print_usage(params, argv[0]);
            return false;
        }
    }
    return true;
}

// --------- Response Handler ------------------
bool handleResponse(int32_t token, std::string_view response) {
    if (!response.empty()) {
        std::cout << response << std::flush;
        answer += std::string(response); // Convert string_view to string to append to answer
    }
    return !_stopFlag.load();
}

// --------- Generate Full Prompt and Process Request ----------------
void processPrompt(const std::string& input, const llm_params& params) {
    // Create full prompt by combining system prompt and user input
    std::string full_prompt = params.system_prompt;
    std::string user_prompt = params.prompt_template;

    // Replace "%1" in the template with the user's input
    size_t pos = user_prompt.find("%1");
    if (pos != std::string::npos) {
        user_prompt.replace(pos, 2, input);
    }

    full_prompt += user_prompt;  // Combine system and user prompt

    // Callback for the prompt (this is a basic implementation)
    auto prompt_callback = [](std::span<const LLModel::Token> batch, bool cached) -> bool {
        // Optionally handle the batch here
        return true;
    };

    // Callback for receiving the response from the model
    auto response_callback = [](int32_t token_id, std::string_view response) -> bool {
        return handleResponse(token_id, response);
    };

    // Create and set prompt context
    LLModel::PromptContext ctx;
    ctx.n_predict = params.max_tokens;  // Adjust as needed
    ctx.top_k = params.top_k;
    ctx.top_p = params.top_p;
    ctx.min_p = params.min_p;
    ctx.temp = params.temperature;
    ctx.n_batch = params.prompt_batch_size;
    ctx.repeat_penalty = params.repeat_penalty;
    ctx.repeat_last_n = params.repeat_penalty_tokens;
    ctx.contextErase = 0.5f;  // Customize if needed

    // Call the prompt method on the model
    model->prompt(full_prompt, prompt_callback, response_callback, ctx);

    std::cout << "\n__DONE__\n" << std::flush;
}

// --------- Main Function ---------------------
int main(int argc, char* argv[]) {
    llm_params params;

    if (!llm_parse_args(argc, argv, params))
        return 1;

    // prompt_context.n_predict = params.max_tokens;

    model = LLModel::Implementation::construct(params.model, params.backend, params.context_length);
    if (!model) {
        std::cerr << "Failed to construct model.\n";
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

    if (!model->loadModel(params.model, params.context_length, params.number_of_gpu_layers)) {
        std::cerr << "Model loading unsuccessful!\n";
        return 1;
    } else {
        std::cout << "Model loaded successfully!\n";
    }

    while (true) {
        std::string command;
        std::getline(std::cin, command);

        if (command == "__EXIT__") break;
        if (command == "__STOP__") {
            _stopFlag.store(true);
            continue;
        }

        if (command == "__PROMPT__") {
            std::string input;
            std::getline(std::cin, input);

            _stopFlag.store(false);
            answer.clear();

            // Process and send the prompt to the model
            processPrompt(input, params);
        }
    }

    return 0;
}
