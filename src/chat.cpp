#include "./header.h"
#include "../phoenix/llmodel.h"
#include "./utils.h"
#include "./parse_json.h"

//////////////////////////////////////////////////////////////////////////
////////////                    ANIMATION                     ////////////
//////////////////////////////////////////////////////////////////////////

std::atomic<bool> stop_display{ false };

void display_frames() {
    const char* frames[] = { ".", ":", "'", ":" };
    int frame_index = 0;
    ConsoleState con_st;
    con_st.use_color = true;
    while (!stop_display) {
        set_console_color(con_st, PROMPT);
        std::cerr << "\r" << frames[frame_index % 4] << std::flush;
        frame_index++;
        set_console_color(con_st, DEFAULT);
        if (!stop_display) {
            std::this_thread::sleep_for(std::chrono::milliseconds(200));
            std::cerr << "\r" << " " << std::flush;
            std::cerr << "\r" << std::flush;
        }
    }
}

void display_loading() {

    while (!stop_display) {


        for (int i = 0; i < 14; i++) {
            fprintf(stdout, ".");
            fflush(stdout);
            std::this_thread::sleep_for(std::chrono::milliseconds(200));
            if (stop_display) { break; }
        }

        std::cout << "\r" << "               " << "\r" << std::flush;
    }
    std::cout << "\r" << " " << std::flush;

}

//////////////////////////////////////////////////////////////////////////
////////////                   /ANIMATION                     ////////////
//////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////
////////////                 CHAT FUNCTIONS                   ////////////
//////////////////////////////////////////////////////////////////////////


std::string get_input(ConsoleState& con_st, std::string& input, chatParams& params) {
    set_console_color(con_st, USER_INPUT);

    std::cout << "\n> ";
    std::getline(std::cin, input);

    std::istringstream iss(input);
    std::string input1, input2;
    std::getline(iss, input1, ' ');
    std::getline(iss, input2, ' ');
    set_console_color(con_st, DEFAULT);
    return input;
}

std::string hashstring = "";
std::string answer = "";

//////////////////////////////////////////////////////////////////////////
////////////                /CHAT FUNCTIONS                   ////////////
//////////////////////////////////////////////////////////////////////////




int main(int argc, char* argv[]) {
    ConsoleState con_st;
    con_st.use_color = true;
    set_console_color(con_st, DEFAULT);

    set_console_color(con_st, PROMPT);
    set_console_color(con_st, BOLD);
    std::cout << APPNAME;
    set_console_color(con_st, DEFAULT);
    set_console_color(con_st, PROMPT);
    std::cout << " (v. " << VERSION << ")";
    set_console_color(con_st, DEFAULT);
    std::cout << "" << std::endl;
    check_avx_support_at_startup();

    chatParams params;

    std::string model_path = "F:/Zeinab/model/Meta-Llama-3-8B-Instruct.Q4_0.gguf";
    std::cout << "Enter your model path:\n";
    set_console_color(con_st, USER_INPUT);
    std::getline(std::cin, model_path);
    set_console_color(con_st, DEFAULT);

    
    params.model = model_path;
    std::string backend = "cuda";
    int n_ctx = 2048;
    int ngl = 100;

    
    LLModel* model = LLModel::Implementation::construct(model_path,backend,n_ctx);
   

    auto devices = LLModel::Implementation::availableGPUDevices();
    if (!devices.empty()) {
        for (const auto& device : devices) {
            //std::cout << "Found GPU: " << device.selectionName() << " with heap size: " << device.heapSize << std::endl;
        }
        // Example: Initialize the first available device
        size_t memoryRequired = devices[0].heapSize;
        const std::string& name = devices[0].name;
        const size_t requiredMemory = model->requiredMem(model_path, n_ctx, ngl);
        auto devices = model->availableGPUDevices(memoryRequired);
        for (const auto& device : devices) {
            if (device.name == name && model->initializeGPUDevice(device.index)) {
                break;
            }
        }
    }

   

    //auto approxDeviceMemGB = [](const LLModel::GPUDevice* dev) {
    //    float memGB = dev->heapSize / float(1024 * 1024 * 1024);
    //    return std::floor(memGB * 10.f) / 10.f; // truncate to 1 decimal place
    //    };

    //std::vector<LLModel::GPUDevice> availableDevices;
    //const LLModel::GPUDevice* defaultDevice = nullptr;
    //const size_t requiredMemory = model->requiredMem(model_path, n_ctx, ngl);
    //availableDevices = model->availableGPUDevices(requiredMemory);
    //std::string unavail_reason;
    //const auto* device = defaultDevice;
    //for (const LLModel::GPUDevice& d : availableDevices) {
    //    if (d.selectionName() == backend) {
    //        device = &d;
    //        break;
    //    }
    //}
    //if (!device) {
    //    // GPU not available
    //}
    //else if (!model->initializeGPUDevice(device->index, &unavail_reason)) {
    //    std::cout << "\n\nHi dear\n\n";
    //}
   




    std::future<void> future;
    stop_display = true;

    if (params.use_animation) { stop_display = false; future = std::async(std::launch::async, display_loading); }

    auto check_model = model->loadModel(model_path,n_ctx , ngl);
    if (check_model == false) {
        if (params.use_animation) {
            stop_display = true;
            future.wait();
            stop_display = false;
        }

        std::cerr << "Error loading: " << params.model.c_str() << std::endl;
        std::cout << "Press any key to exit..." << std::endl;
        std::cin.get();
        return 0;
    }
    else {
        if (params.use_animation) {
            stop_display = true;
            future.wait();
        }
        std::cout << "\r" << APPNAME << ": done loading!" << std::flush;
    }


    //////////////////////////////////////////////////////////////////////////
    ////////////            PROMPT LAMBDA FUNCTIONS               ////////////
    //////////////////////////////////////////////////////////////////////////


    auto prompt_callback = [](int32_t token_id) {
        // You can handle prompt here if needed
        return true;
        };


    auto response_callback = [](int32_t token_id, const std::string responsechars_str) {
        const char* responsechars = responsechars_str.c_str();


        if (!(responsechars == nullptr || responsechars[0] == '\0')) {
            // stop the animation, printing response
            if (stop_display == false) {
                stop_display = true;
                std::this_thread::sleep_for(std::chrono::milliseconds(200));
                std::cerr << "\r" << " " << std::flush;
                std::cerr << "\r" << std::flush;
                if (answer != "") { std::cout << answer; }
            }

            std::cout << responsechars << std::flush;
            answer += responsechars;
        }

        return true;
        };

    auto recalculate_callback = [](bool is_recalculating) {
        // You can handle recalculation requests here if needed
        return is_recalculating;
        };


    //////////////////////////////////////////////////////////////////////////
    ////////////         PROMPT TEXT AND GET RESPONSE             ////////////
    //////////////////////////////////////////////////////////////////////////
    model->setThreadCount(4);
    std::string input = "";

    LLModel::PromptContext prompt_context;
    

    //main chat loop.
    if (!params.no_interactive && !sighup_received) {
        input = get_input(con_st, input, params);

        //Interactive mode. We have a prompt.
        if (params.prompt != "") {
            if (params.use_animation) { stop_display = false; future = std::async(std::launch::async, display_frames); }
            if (params.b_token != "") { answer = answer + params.b_token; if (!params.use_animation) { std::cout << params.b_token; } }
            model->prompt( input ,"<|start_header_id|>user<|end_header_id|>\n\n%1<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n%2<|eot_id|>" ,
                prompt_callback, response_callback, recalculate_callback,prompt_context , false, nullptr);
            if (params.e_token != "") { std::cout << params.e_token; answer = answer + params.e_token; }
            if (params.use_animation) { stop_display = true; future.wait(); stop_display = false; }
            if (params.save_log != "") { save_chat_log(params.save_log, (params.prompt + " " + input + params.default_footer).c_str(), answer.c_str()); }

            //Interactive mode. Else get prompt from input.
        }
        else {
            if (params.use_animation) { stop_display = false; future = std::async(std::launch::async, display_frames); }
            if (params.b_token != "") { answer = answer + params.b_token; if (!params.use_animation) { std::cout << params.b_token; } }
            model->prompt(input, "<|start_header_id|>user<|end_header_id|>\n\n%1<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n%2<|eot_id|>",
                prompt_callback, response_callback, recalculate_callback, prompt_context, false, nullptr);
            if (params.e_token != "") { std::cout << params.e_token; answer = answer + params.e_token; }
            if (params.use_animation) { stop_display = true; future.wait(); stop_display = false; }
            if (params.save_log != "") { save_chat_log(params.save_log, (params.default_prefix + params.default_header + input + params.default_footer).c_str(), answer.c_str()); }
        }
        //Interactive and continuous mode. Get prompt from input.

        while (!params.run_once && !sighup_received) {
            answer = ""; //New prompt. We stored previous answer in memory so clear it.
            input = get_input(con_st, input, params);
            if (params.use_animation) { stop_display = false; future = std::async(std::launch::async, display_frames); }
            if (params.b_token != "") { answer = answer + params.b_token; if (!params.use_animation) { std::cout << params.b_token; } }
            model->prompt(input, "<|start_header_id|>user<|end_header_id|>\n\n%1<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n%2<|eot_id|>",
                prompt_callback, response_callback, recalculate_callback, prompt_context, false, nullptr);
            if (params.e_token != "") { std::cout << params.e_token; answer = answer + params.e_token; }
            if (params.use_animation) { stop_display = true; future.wait(); stop_display = false; }
            if (params.save_log != "") { save_chat_log(params.save_log, (params.default_prefix + params.default_header + input + params.default_footer).c_str(), answer.c_str()); }

        }

        //No-interactive mode. Get the answer once from prompt and print it.
    }
    else {
        if (params.use_animation) { stop_display = false; future = std::async(std::launch::async, display_frames); }
        if (params.b_token != "") { answer = answer + params.b_token; if (!params.use_animation) { std::cout << params.b_token; } }
        model->prompt(input, "<|start_header_id|>user<|end_header_id|>\n\n%1<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n%2<|eot_id|>",
            prompt_callback, response_callback, recalculate_callback, prompt_context, false, nullptr);
        if (params.e_token != "") { std::cout << params.e_token; answer = answer + params.e_token; }
        if (params.use_animation) { stop_display = true; future.wait(); stop_display = false; }
        if (params.save_log != "") { save_chat_log(params.save_log, (params.prompt + params.default_footer).c_str(), answer.c_str()); }
        std::cout << std::endl;
    }


    set_console_color(con_st, DEFAULT);
    return 0;
}




