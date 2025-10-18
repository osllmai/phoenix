#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <cstdlib>
#include <limits>
#include <chrono>
#include <thread>
#include <mutex>
#include <atomic>
#include <cmath>

#if __has_include(<span>)
#include <span>
#else
namespace std {
    template <typename T>
    class span {
    public:
        span(const T* data, size_t size) : data_(data), size_(size) {}
        const T* data() const { return data_; }
        size_t size() const { return size_; }
    private:
        const T* data_;
        size_t size_;
    };
}
#endif

#include <gpt4all-backend/llmodel.h>
#include "llm_params.h"

// --------- Global Variables -------------------
std::string answer = "";
LLModel* model = nullptr;
std::atomic<bool> _stopFlag = false;
llm_params params;

std::thread promptThread;
std::mutex promptMutex;
std::atomic<bool> promptRunning = false;

// --------- Response Handler ------------------
bool handleResponse(int32_t token, std::string_view response) {
    if (_stopFlag.load()) return false;

    if (!response.empty()) {
        if (params.stream) {
            std::cout << response << std::flush;
        }
        answer += std::string(response);
    }
    return true;
}

// --------- Generate Full Prompt and Process Request ----------------
void processPrompt(const std::string& input) {
    std::string full_prompt = params.system_prompt;
    std::string user_prompt = params.prompt_template;

    size_t pos = user_prompt.find("%1");
    if (pos != std::string::npos) {
        user_prompt.replace(pos, 2, input);
    }

    full_prompt += user_prompt;

    auto prompt_callback = [](std::span<const LLModel::Token> batch, bool cached) -> bool {
        return true;
        };

    auto response_callback = [](int32_t token_id, std::string_view response) -> bool {
        return handleResponse(token_id, response);
        };

    LLModel::PromptContext promptContext;
    promptContext.n_predict = params.max_tokens;
    promptContext.top_k = params.top_k;
    promptContext.top_p = params.top_p;
    promptContext.min_p = params.min_p;
    promptContext.temp = params.temperature;
    promptContext.n_batch = params.prompt_batch_size;
    promptContext.repeat_penalty = params.repeat_penalty;
    promptContext.repeat_last_n = params.repeat_penalty_tokens;
    promptContext.contextErase = 0.5f;

    model->prompt(full_prompt, prompt_callback, response_callback, promptContext);

    if (!params.stream) {
        std::cout << answer << std::flush;
    }

    std::cout << "__DONE_PROMPTPROCESS__" << std::flush;
}

float approxDeviceMemGB(const LLModel::GPUDevice* dev) {
    float memGB = dev->heapSize / float(1024 * 1024 * 1024);
    return std::floor(memGB * 10.f) / 10.f;
}

// --------- Main Function ---------------------
int main(int argc, char* argv[]) {
    auto startTime = std::chrono::steady_clock::now();

    if (!llm_parse_args(argc, argv, params)) {
        std::cerr << "Error: Argument parsing failed.\n";
        return 1;
    }

    std::string backend = "auto";

#if defined(__APPLE__) && defined(__aarch64__)
    if (params.device == "CPU") {
        backend = "cpu";
    }
    else if (params.force_metal) {
        backend = "metal";
    }
#elif defined(_WIN32) || defined(_WIN64)
    if (params.device.rfind("CUDA", 0) == 0) {
        backend = "cuda";
    }
#else
    if (params.device.rfind("CUDA", 0) == 0) {
        backend = "cuda";
    }
#endif

    std::cout << "Using backend: " << backend << std::flush;

    try {
        model = LLModel::Implementation::construct(params.model, backend, params.context_length);
    }
    catch (const LLModel::MissingImplementationError& e) {
        std::cerr << "Missing implementation: " << e.what() << std::flush;
        return 1;
    }
    catch (const LLModel::UnsupportedModelError& e) {
        std::cerr << "Unsupported model: " << e.what() << std::flush;
        return 1;
    }
    catch (const LLModel::BadArchError& e) {
        std::cerr << "Bad architecture: " << e.what() << " (arch: " << e.arch() << ")\n" << std::flush;
        return 1;
    }

    if (!model) {
        std::cerr << "Model construction failed.\n" << std::flush;
        return 1;
    }

    const size_t requiredMemory = model->requiredMem(params.model, params.context_length, params.number_of_gpu_layers);
    auto availableDevices = model->availableGPUDevices(requiredMemory);

    std::cout << "\n--- Available GPU Devices ---\n" << std::flush;
    if (availableDevices.empty()) {
        std::cout << "No GPU devices available.\n" << std::flush;
    }
    else {
        for (const auto& device : availableDevices) {
            std::cout << "Index: " << device.index << "\n";
            std::cout << "Name: " << device.name << "\n";
            std::cout << "Backend: " << device.backendName() << "\n";
            std::cout << "Selection Name: " << device.selectionName() << "\n";
            std::cout << "Total Memory (approx. GB): " << approxDeviceMemGB(&device) << "\n" << std::flush;
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
                }
                else {
                    std::cerr << "GPU init failed: " << reason << std::flush;
                }
            }
        }
    }
#endif

    bool success = model->loadModel(params.model, params.context_length, params.number_of_gpu_layers);

    if (!success && !usingCPU) {
        std::cerr << "GPU loading failed, retrying on CPU...\n" << std::flush;
        success = model->loadModel(params.model, params.context_length, 0);
        if (!success) {
            std::cerr << "Fallback to CPU also failed.\n" << std::flush;
            return 1;
        }
    }

    if (!success) {
        std::cerr << "Model load failed completely.\n" << std::flush;
        return 1;
    }

    auto endTime = std::chrono::steady_clock::now();
    std::chrono::duration<double> elapsedSeconds = endTime - startTime;
    std::cout << "Model loaded successfully on " << (usingCPU ? "CPU" : "GPU") << std::flush;
    if (selectedDevice) {
        std::cout << "Device name: " << selectedDevice->name << "\n";
        std::cout << "Memory (GB): " << approxDeviceMemGB(selectedDevice) << "\n";
        std::cout << "Backend: " << selectedDevice->backendName() << "\n";
    }
    std::cout << "Model loading duration: " << elapsedSeconds.count() << " seconds\n" << std::flush;

    std::cout << "__LoadingModel__Finished__" << std::flush;

    while (true) {
        std::string command;
        std::getline(std::cin, command);

        if (command == "__EXIT__") break;

        if (command == "__PARAMS_SETTINGS__") {
            std::string line;
            while (std::getline(std::cin, line)) {
                if (line == "__END_PARAMS_SETTINGS__") break;

                auto pos = line.find('=');
                if (pos != std::string::npos) {
                    std::string key = line.substr(0, pos);
                    std::string val = line.substr(pos + 1);

                    if (key == "stream") {
                        std::transform(val.begin(), val.end(), val.begin(), ::tolower);
                        params.stream = (val == "true" || val == "1");
                    }
                    else if (key == "prompt_template") {
                        params.prompt_template = val;
                    }
                    else if (key == "system_prompt") {
                        params.system_prompt = val;
                    }
                    else if (key == "n_predict") {
                        params.max_tokens = std::stoi(val);
                    }
                    else if (key == "top_k") {
                        params.top_k = std::stoi(val);
                    }
                    else if (key == "top_p") {
                        params.top_p = std::stof(val);
                    }
                    else if (key == "min_p") {
                        params.min_p = std::stof(val);
                    }
                    else if (key == "temp") {
                        params.temperature = std::stof(val);
                    }
                    else if (key == "n_batch") {
                        params.prompt_batch_size = std::stoi(val);
                    }
                    else if (key == "repeat_penalty") {
                        params.repeat_penalty = std::stof(val);
                    }
                    else if (key == "repeat_last_n") {
                        params.repeat_penalty_tokens = std::stoi(val);
                    }
                }
            }
            continue;
        }

        if (command == "__PROMPT__") {
            std::string input, line;
            while (std::getline(std::cin, line)) {
                if (line == "__END__") break;
                input += line + "\n";
            }

            _stopFlag.store(false);
            answer.clear();

            if (promptRunning) {
                std::cout << "A prompt is already running. Please wait or stop it.\n" << std::flush;
                continue;
            }

            if (promptThread.joinable()) {
                promptThread.join();
            }

            promptRunning = true;
            promptThread = std::thread([input]() {
                std::lock_guard<std::mutex> lock(promptMutex);
                processPrompt(input);
                promptRunning = false;
                });
        }

        if (command == "__STOP__") {
            _stopFlag.store(true);

            if (promptThread.joinable()) {
                try {
                    promptThread.join();
                }
                catch (const std::system_error& e) {
                    std::cerr << "Thread join error: " << e.what() << std::endl;
                }
            }

            promptRunning = false;
            std::cout << "Prompt stopped.\n" << std::flush;
            continue;
        }
    }

    std::cout << "Exiting.\n" << std::flush;
    return 0;
}
