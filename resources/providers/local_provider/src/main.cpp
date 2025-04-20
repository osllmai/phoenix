#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <cstdlib>
#include <limits>
#include <chrono>

#include <gpt4all-backend/llmodel.h>
#include "llm_params.h"

// --------- Global Variables -------------------
std::string answer = "";
LLModel* model = nullptr;
std::atomic<bool> _stopFlag = false;

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

float approxDeviceMemGB(const LLModel::GPUDevice *dev) {
    float memGB = dev->heapSize / float(1024 * 1024 * 1024);
    return std::floor(memGB * 10.f) / 10.f;
}

// --------- Main Function ---------------------
int main(int argc, char* argv[]) {
    auto startTime = std::chrono::steady_clock::now();

    llm_params params;
    if (!llm_parse_args(argc, argv, params)) {
        std::cerr << "Error: Argument parsing failed.\n";
        return 1;
    }

    std::string backend = "auto";
#if defined(__APPLE__) && defined(__aarch64__)
    if (params.device == "CPU") {
        backend = "cpu";
    } else if (params.force_metal) {
        backend = "metal";
    }
#else
    if (params.device.rfind("CUDA", 0) == 0) {
        backend = "cuda";
    }
#endif

    std::cout << "Using backend: " << backend << "\n";
    try {
        model = LLModel::Implementation::construct(params.model, backend, params.context_length);
    } catch (const LLModel::MissingImplementationError &e) {
        std::cerr << "Missing implementation: " << e.what() << "\n";
        return 1;
    } catch (const LLModel::UnsupportedModelError &e) {
        std::cerr << "Unsupported model: " << e.what() << "\n";
        return 1;
    } catch (const LLModel::BadArchError &e) {
        std::cerr << "Bad architecture: " << e.what() << " (arch: " << e.arch() << ")\n";
        return 1;
    }

    if (!model) {
        std::cerr << "Model construction failed.\n";
        return 1;
    }

    const size_t requiredMemory = model->requiredMem(params.model, params.context_length, params.number_of_gpu_layers);
    auto availableDevices = model->availableGPUDevices(requiredMemory);

    std::cout << "\n--- Available GPU Devices ---\n";
    if (availableDevices.empty()) {
        std::cout << "No GPU devices available.\n";
    } else {
        for (const auto& device : availableDevices) {
            std::cout << "Index: " << device.index << "\n";
            std::cout << "Name: " << device.name << "\n";
            std::cout << "Backend: " << device.backendName() << "\n";
            std::cout << "Selection Name: " << device.selectionName() << "\n";
            std::cout << "Total Memory (approx. GB): " << approxDeviceMemGB(&device) << "\n";
            std::cout << "--------------------------------\n";
        }
    }



    const LLModel::GPUDevice* selectedDevice = nullptr;
    bool usingCPU = true;

#if defined(__APPLE__) && defined(__aarch64__)
    if (model->implementation().buildVariant() == "metal") {
        usingCPU = false;
    }
#else
    if (params.device != "CPU") {

        for (const auto& device : availableDevices) {

            if (params.device == "Auto" || device.selectionName() == params.device) {
                std::string reason;
                if (model->initializeGPUDevice(device.index, &reason)) {
                    selectedDevice = &device;
                    usingCPU = false;
                    break;
                } else {
                    std::cerr << "GPU init failed: " << reason << "\n";
                }
            }
        }
    }
#endif

    bool success = model->loadModel(params.model, params.context_length, params.number_of_gpu_layers);

    if (!success && !usingCPU) {
        std::cerr << "GPU loading failed, retrying on CPU...\n";
        success = model->loadModel(params.model, params.context_length, 0);
        if (!success) {
            std::cerr << "Fallback to CPU also failed.\n";
            return 1;
        }
    }

    if (!success) {
        std::cerr << "Model load failed completely.\n";
        return 1;
    }

    auto endTime = std::chrono::steady_clock::now();
    std::chrono::duration<double> elapsedSeconds = endTime - startTime;
    std::cout << "Model loaded successfully on " << (usingCPU ? "CPU" : "GPU") << "\n";
    if (selectedDevice) {
        std::cout << "Device name: " << selectedDevice->name << "\n";
        std::cout << "Memory (GB): " << approxDeviceMemGB(selectedDevice) << "\n";
        std::cout << "Backend: " << selectedDevice->backendName() << "\n";
    }
    std::cout << "Model loading duration: " << elapsedSeconds.count() << " seconds\n";

    // Command loop
    while (true) {
        std::cout << ">> ";
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
            std::cout << "Prompting: " << input << "\n";
            processPrompt(input, params);
        }
    }

    std::cout << "Exiting.\n";
    return 0;
}
