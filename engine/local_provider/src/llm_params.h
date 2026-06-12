#ifndef LLM_PARAMS_H
#define LLM_PARAMS_H

#include <string>
#include <vector>
#include <iostream>
#include <cstring>
#include <cstdlib>     // for exit()
#include <algorithm>   // for std::transform
#include <cctype>      // for ::tolower

// --------- Struct for Parameters --------------
struct llm_params {
    std::string model = "models/model.gguf";
    std::string device = "Auto";
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
    bool force_metal = false;
};

// --------- Print Help Message -----------------
inline void llm_print_usage(const llm_params& p, const char* progname) {
    std::cout <<
        "Usage: " << progname << " [options]\n\n"
        "Options:\n"
        "  --model <path>                     Path to model file (default: models/model.gguf)\n"
        "  --device <cpu|cuda|auto>           Device to use (default: Auto)\n"
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
        "  --gpu-layers <int>                 Number of GPU layers (default: 80)\n"
        "  --force-metal                      Force use of Metal (macOS only)\n";
}

// --------- Argument Parser -------------------
inline bool llm_parse_args(int argc, char* argv[], llm_params& params) {
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];

        if (arg == "--help") {
            llm_print_usage(params, argv[0]);
            std::exit(0);
        }
        else if (arg == "--model" && i + 1 < argc) {
            params.model = argv[++i];
        }
        else if (arg == "--device" && i + 1 < argc) {
            params.device = argv[++i];
        }
        else if (arg == "--stream" && i + 1 < argc) {
            std::string val = argv[++i];
            std::transform(val.begin(), val.end(), val.begin(),
                [](unsigned char c) { return std::tolower(c); });
            params.stream = (val == "true");
        }
        else if (arg == "--prompt-template" && i + 1 < argc) {
            params.prompt_template = argv[++i];
        }
        else if (arg == "--system-prompt" && i + 1 < argc) {
            params.system_prompt = argv[++i];
        }
        else if (arg == "--temperature" && i + 1 < argc) {
            params.temperature = std::stod(argv[++i]);
        }
        else if (arg == "--top-k" && i + 1 < argc) {
            params.top_k = std::stoi(argv[++i]);
        }
        else if (arg == "--top-p" && i + 1 < argc) {
            params.top_p = std::stod(argv[++i]);
        }
        else if (arg == "--min-p" && i + 1 < argc) {
            params.min_p = std::stod(argv[++i]);
        }
        else if (arg == "--repeat-penalty" && i + 1 < argc) {
            params.repeat_penalty = std::stod(argv[++i]);
        }
        else if (arg == "--prompt-batch-size" && i + 1 < argc) {
            params.prompt_batch_size = std::stoi(argv[++i]);
        }
        else if (arg == "--max-tokens" && i + 1 < argc) {
            params.max_tokens = std::stoi(argv[++i]);
        }
        else if (arg == "--repeat-penalty-tokens" && i + 1 < argc) {
            params.repeat_penalty_tokens = std::stoi(argv[++i]);
        }
        else if (arg == "--context-length" && i + 1 < argc) {
            params.context_length = std::stoi(argv[++i]);
        }
        else if (arg == "--gpu-layers" && i + 1 < argc) {
            params.number_of_gpu_layers = std::stoi(argv[++i]);
        }
        else if (arg == "--force-metal") {
            params.force_metal = true;
        }
        else {
            std::cerr << "Unknown or incomplete argument: " << arg << "\n";
            llm_print_usage(params, argv[0]);
            return false;
        }
    }
    return true;
}

#endif // LLM_PARAMS_H
