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
    std::cout << " (v. " << VERSION << ")\n\n";
    std::cout << " .----------------.  .----------------.  .----------------.  .----------------.  .-----------------. .----------------.  .----------------. \n";
    std::cout << "| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |\n";
    std::cout << "| |   ______     | || |  ____  ____  | || |     ____     | || |  _________   | || | ____  _____  | || |     _____    | || |  ____  ____  | |\n";
    std::cout << "| |  |_   __ \\   | || | |_   ||   _| | || |   .'    `.   | || | |_   ___  |  | || ||_   \\|_   _| | || |    |_   _|   | || | |_  _||_  _| | |\n";
    std::cout << "| |    | |__) |  | || |   | |__| |   | || |  /  .--.  \\  | || |   | |_  \\_|  | || |  |   \\ | |   | || |      | |     | || |   \\ \\  / /   | |\n";
    std::cout << "| |    |  ___/   | || |   |  __  |   | || |  | |    | |  | || |   |  _|  _   | || |  | |\\ \\| |   | || |      | |     | || |    > `' <    | |\n";
    std::cout << "| |   _| |_      | || |  _| |  | |_  | || |  \\  `--'  /  | || |  _| |___/ |  | || | _| |_\\   |_  | || |     _| |_    | || |  _/ /'`\\ \\_  | |\n";
    std::cout << "| |  |_____|     | || | |____||____| | || |   `.____.'   | || | |_________|  | || ||_____||____| | || |    |_____|   | || | |____||____| | |\n";
    std::cout << "| |              | || |              | || |              | || |              | || |              | || |              | || |              | |\n";
    std::cout << "| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |\n";
    std::cout << " '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' \n";
    set_console_color(con_st, DEFAULT);
    std::cout << "" << std::endl;
    check_avx_support_at_startup();

    chatParams params;

    std::string model_path = "F:/Zeinab/model/Meta-Llama-3-8B-Instruct.Q4_0.gguf";
    std::cout << "Enter your model path:\n";
    set_console_color(con_st, USER_INPUT);
    std::getline(std::cin, model_path);
    set_console_color(con_st, DEFAULT);

    std::string backend = "auto";
    // it will consider device for GPU/CPU
    int device ;
    std::string cin_str;
#if(WIN32)

    std::cout << "\nDevices: \n\t1. CPU \n\t2. GPU\n\nPlease enter your desired option :\n";
    set_console_color(con_st, USER_INPUT);
    std::cin >> device;
    std::getline(std::cin, cin_str);
    set_console_color(con_st, DEFAULT);
    if (device == 2) backend = "cuda";
#endif
    params.model = model_path;

    LLModel::PromptContext prompt_context;
    prompt_context.n_ctx = 2048;
    int ngl = 100;
    LLModel* model = LLModel::Implementation::construct(model_path, backend, prompt_context.n_ctx);
    std::string prompt_template = "<|start_header_id|>user<|end_header_id|>\n\n%1<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n%2<|eot_id|>";
    

    int option;
    do {
  
        std::cout << "\nMenu: \n\t1. New chat \n\t2. Prompt Template \n\t3. Context Length \n\t4. Prompt Batch Size \n\t5. Top-P \n\t6. Min-P";
        std::cout << "\n\t7. GPU Layers \n\t8. Max Length \n\t9. Temperature \n\t10. Top-K \n\t11. Repeat Penalty Tokens \n\t12. Repeat Penalty ";

        std::cout << "\n\nPlease enter your desired option :\n";
        set_console_color(con_st, USER_INPUT);
        std::cin >> option;
        std::getline(std::cin, cin_str);
        set_console_color(con_st, DEFAULT);

        int number;
        std::string str;
        if (option == 2 && option != 1) {
            std::cout << "\nPlease enter your desired value: :\n";
            set_console_color(con_st, USER_INPUT);
            std::getline(std::cin, str);
            set_console_color(con_st, DEFAULT);
        }
        else if(option != 1){
            std::cout << "\nPlease enter your desired value: :\n";
            set_console_color(con_st, USER_INPUT);
            std::cin >> number;
            std::getline(std::cin, cin_str);
            set_console_color(con_st, DEFAULT);
        }

        switch (option){
        case 2:
            prompt_template = str;
            break;
        case 3:
            prompt_context.n_ctx = number;
            break;
        case 4:
            prompt_context.n_batch = number;
            break;
        case 5:
            prompt_context.top_p = number;
            break;
        case 6:
            prompt_context.min_p = number;
            break;
        case 7:
            ngl = number;
            break;
        case 8:
            break;
        case 9:
            prompt_context.temp = number;
            break;
        case 10:
            prompt_context.top_k = number;
            break;
        case 11:
            prompt_context.repeat_last_n = number;
            break;
        case 12:
            prompt_context.repeat_penalty = number;
            break;
        default:
            break;
        }
    } while (option != 1);

#if(WIN32)
    if (backend == "cuda") {
        auto devices = LLModel::Implementation::availableGPUDevices();
        if (!devices.empty()) {
            for (const auto& device : devices) {
                //std::cout << "Found GPU: " << device.selectionName() << " with heap size: " << device.heapSize << std::endl;
            }
            // Example: Initialize the first available device
            size_t memoryRequired = devices[0].heapSize;
            const std::string& name = devices[0].name;
            const size_t requiredMemory = model->requiredMem(model_path, prompt_context.n_ctx, ngl);
            auto devices = model->availableGPUDevices(memoryRequired);
            for (const auto& device : devices) {
                if (device.name == name && model->initializeGPUDevice(device.index)) {
                    break;
                }
            }
        }
    }
#endif

    std::future<void> future;
    stop_display = true;

    if (params.use_animation) { stop_display = false; future = std::async(std::launch::async, display_loading); }

    auto check_model = model->loadModel(model_path, prompt_context.n_ctx , ngl);
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
    ////////////            PRINT LOGO IS HERE ...               ////////////
    //////////////////////////////////////////////////////////////////////////
    // std::cout << std::endl;
    // std::cout << " .----------------.  .----------------.  .----------------.  .----------------.  .-----------------. .----------------.  .----------------. \n";
    // std::cout << "| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |\n";
    // std::cout << "| |   ______     | || |  ____  ____  | || |     ____     | || |  _________   | || | ____  _____  | || |     _____    | || |  ____  ____  | |\n";
    // std::cout << "| |  |_   __ \\   | || | |_   ||   _| | || |   .'    `.   | || | |_   ___  |  | || ||_   \\|_   _| | || |    |_   _|   | || | |_  _||_  _| | |\n";
    // std::cout << "| |    | |__) |  | || |   | |__| |   | || |  /  .--.  \\  | || |   | |_  \\_|  | || |  |   \\ | |   | || |      | |     | || |   \\ \\  / /   | |\n";
    // std::cout << "| |    |  ___/   | || |   |  __  |   | || |  | |    | |  | || |   |  _|  _   | || |  | |\\ \\| |   | || |      | |     | || |    > `' <    | |\n";
    // std::cout << "| |   _| |_      | || |  _| |  | |_  | || |  \\  `--'  /  | || |  _| |___/ |  | || | _| |_\\   |_  | || |     _| |_    | || |  _/ /'`\\ \\_  | |\n";
    // std::cout << "| |  |_____|     | || | |____||____| | || |   `.____.'   | || | |_________|  | || ||_____||____| | || |    |_____|   | || | |____||____| | |\n";
    // std::cout << "| |              | || |              | || |              | || |              | || |              | || |              | || |              | |\n";
    // std::cout << "| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |\n";
    // std::cout << " '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' \n";


    set_console_color(con_st, PROMPT);
    // add new line
    std::cout << std::endl;

    const char* ascii_art = R"(

&&&$$$$$$$$$$$$$$$$$$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX$$$$$$$$$$$$$$$$$$$$&&&&&
&&$$$$$$$$$$$$$x$$$X$$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX$$$$$$$$$x$$$$$$$$$&&&&
&$$$$$$$$$$$$X:X$$$&$XXXXXXXXXXXXXXxx+;::::::::::::::;+xxXXXXXXXXXXX$$$&&$$$X;X$$$$$$$$&&&
$$$$$$$$$$$$X:;$$$&&XXXXXXXXXXx+;::+xX$&&&&$$$$$$$&&&$$Xx;::+XXXXXXXXXX$&&$$X;:$$$$$$$$$$&
$$$$$$$X$$$$;.;$+X&$XXXXXXXx:.:X&&&$+::::::::;;:::;;;;:;x&&&&$XXXXXXXXXX$&x+$;.+$$$$X$$$$$
$$$$$$$;$$$X:.:x:$&$XXXXx;:+$&$x;.:;+X&&&&&&&&&&&&&&&&$Xxx+;+$$&$$XXXXXX$&X.+::;$$$X+$$$$$
$$$$$$$:$$$X:...:$&$XX+:+$&$+::+X&&&&&$X++;;::::;;;+xX&&&&&$$X++x$&$$XXX$&x...:;$$$x+$$$$$
$$$$$$$:+$$$::...X&$;.x&&x::x&&&&$+:.............;;.....:;X&&&&&Xx+X&&$X&&;...:+$$$.x$$$$$
$$$$$$&+:x$$;:.;:;&&$&&x:+$&&&x:..;+Xxx+;:::::....:$x..+xx+::+$&&&$X+x&&&X.x.::X$X.;X&$$$$
$$$$$$&X;:x$x;;:+:x&&x:x&&&X;.:x$$X;:............x:+$x...:+X$xXX$&&&&XX&$:+:;;x$X:;x&&$$$$
$$$$$$$&x;.+&x++;x.+&$&&&$:.x$&$+... ...::.......X+xX&:::.::+$$$$X$&&&&X.+;x+x&x:;+&&X&$$$
$$$$$$X&&x;;:$x+x;$;x&X$x.+&&&+....:x+;........:X&X+X&.+;:::::X&&&$Xx&x;X+xxX$::;x&&xX&$$$
$$$$&&++&&$++:+$xx+Xx+$X+$&&$:...;x+:.....;++xXXx;x$&+;X:::::::X&X+$$+XX+xX$+;++$&&+;$&$$$
$$$$$&X;:X&&X++;xXxxX$+X&+;$:..:xx+.  .;x;;;;+xXXxx&X$&x::;;::x$;x&x+$Xxx$x;++X&&x:;x&&$$$
$$$$$&&x;:;$&&Xx+;XxXx$x+$$x$x;XX+.. .+;X$$+;::;x$&&&&x::::x+$$X&X+X&XXXx++x$&&X::++&&&$$$
$$$$$&&&x++::x$&$xx++X&$X+x$$&&XX;+: .x$&&&$&&&&&$XxX&&&&$;:X&&+xX$$xXXxX&$x++xXXxX&&&$$$$
$$$$$$&&&XxXX+;+x&&XxxxX$Xx+x&&$XX+.:X$&&&$&&&&&&$XxX&&&&$;:X&&+xX$$xXXxX&$x++xXXxX&&&$$$$
$$$$$$$&&&&xXXXXXXx$$$X$xx$$XX$&$X;.xX:...:&&&&&&XXxX&;:::x&$X$$$+x$X$&$XXX$XXXX&&&&$$$$$$
$$$$$$x.$&&&&$XX$$$$$&&$$$xxX&$&&X+.......:&$$&X&$xxX&$::+&&$&XxX$$$&&$$$$&$X$&&&&&&&$$$$$
$$$$$$;.&&$X&&&$$&&x::+x$&&$X$$&&&$;....;X&$xxXX&$X+x&X:x&&&$$$&$X+;:::x&&$$&&Xxx&&&&$$$$$
$$$$$X:x&&&&x+xX$&&&&$x+;+XXXX$$&&&&+:X&X;::;+x&&XX;X$x&&&$$$$XXx+++X$&&&&$Xxxx$&&&&&$$$$$
$$$$$x.$&&&&&&$XX$$$&&&&&&&$$XxXXX$$&&$::::x;x&$X$:x&&&$$XXxxxxX&&&&&&&$$$$$$&&&$$&&&&$$$$
$$$$$+:&&$&+&$$XXx++xxX$&&Xx++xX$&&&&X:::;x:X$Xx$x$&&&&&&&$$XXXXX$&$$XXxx++++x$&$X&$&&$$$$
$$$$$+;&&XX+&&&X+;++xX$&&&$&&&&&&&$$&+:;;x+x&Xx$&&&&&&&$X$&&&&&&$$$&&$Xxx+xX&&&&$+&$$&$$$$
$$$$$+;&$Xx+&&&&&&&&&$XxXX$$$$$&$+$&&+:X;XXx&Xx&&&&&&&$&$xx$$$$$$$XXxxX&&&&&&&&&$+$$$&$$$$
$$$$$+;&$X+;&&$$&&$+;;+x$$xXX$X$X&&$&X:X+x$&&XxX&&$&&&$$$&&&$x$XXxX$Xx++X&&$$$$&$;$X$&$$$$
$$$$$x;&&x+;$$$$$$$&&&&X+xxX$+X$X$$$&&++$+x$&$xXX$&$$&&&XX$$$XxXXxx++$&&&&$$$$$&X;Xx&&$$$$
$$$$$X:$&X+:x$&&$$$&&&XXX$&X+xX$$xXX&&&Xx$+xX&$xXXxX$$$$&&&&$$X+x&&&$$&&&&$$&&$$+;xX&&$$$$
$$$$$$;x&$x++X&X+X$&&&&&&&&$&&&x+x$$X$&&&&&XxX$$XxXX+xX+x$$$&&&&&&&&&&&&&Xx&&&&X;+x$&$$$$$
$$$$$&x:&&xxxxX++$&$;+&&&&&$&&&&&&XX$&&&&$&&&$xXXXXx$&x;++;::;;++++;;X&&$;x&$$$+Xxx&&$$$$$
$$$$$&&:x&&xX$$X$&+.x&&&&X:x&&&&&&&&&&&$$$$&&$&&$XXXXx$&&$Xxx++xxX$&&&$x;x&&xX&$XX&&&$$$$$
$$$$$$&X;$&&XX$&&+:;$&&&X:;x&&&&xX&&&&&&&$$&$X&&&&&XxXX$&&&&$&&&&&&$XX$&&&x:;$&$$&&&$&&$$$
$$$$$$&&x+&&&$$&X;.;&&&&+;;+&&X:X&&x;&&&&&&+;&&X$&&&&++X$&&&$$X&$$&&$Xx+;;:;$&$$&&&$$&&$$$
$$$$$$$&&+X&&&&&x:.;$$X&Xx++x$:;&&$;&&$x+:;X&&xXX&&&&&;+X&&$$$$X&&XX&&&&&&&&$$&&&&$$&&$$$$
$$$$$$$$&$;X&&&&x:.:;+&&&&XxXx;:&&&;x&&&&&&&x+xx$&$$$&$;X&&$$x$$X&$xxX&&&&X+;&&&&&$&&$$$$$
$$$$$$$$$&&;x&&&x::::;&&&&&&$$+;:&&&+:;xx;:;++$&$XX$&$&;$$&$X$X&x$&$xxX&&X+x+;$&&$&&$$$$$$
$$$$$$$$$$&&+x&&$;;;+:x&&&X&&&$xx;+$&&$XXXX$&$x+xx$&$$&x&$&$XXx&$x$&&x+$&XxX$&&$$&&$$$$$$$
$$$$$$$$$$$&&X+&&X;++x:+&&&XX&&&$xx+;;:;;:::::+xX&&X$&&&$$&$XXx$$+$&&$++&&&&&&&&&$$$$$$$$$
$$$$$$$$$$$$&&&;X&$;xxX+;X&&$;x$&&$$XXxx+++xXX$&X+x$&&&$$&&XxXx$$+$&&$++&&&&&&&&&$$$$$$$$$
$$$$$$$$$$$$$&&&XX&&xxX$$Xx$&&$x;+xX$$$$$$$$Xx++x$&&&$X$&&$xXxx$xx$&&$++&&&&&&&$$$$$$$$$$$
$$$$$$$$$$$$$$$&&&$&&&XxXX$$$&&&&$Xx+++++++xxX$&&XX$xxX&&&xxx;$X+X$&&$;X&&&&&&$$$$$$$$$$$$
&$$$$$$$$$$$$$$$$&&&&&&&&&&&$$&&&&&&&&&&&&&&&&X+xx;xx$&&$+x;;&X;xx$&&X+&&&&&$$$$$$$$$$$$$$
&$$$$$$$$$$$$$$$$$$$$&&&&xxxX$&$$Xx;:;+++++x++;:;+xX&&&x++;+$$;++$&&$+$&&&$$$$$$$$$$$$$$$&
&&&$$$$$$$$$$$$$$$$$$$$&&&&$X;:::::.....::::::;xX&&&$x++;;x&x::+$&&$X&&&$$$$$$$$$$$$$$$&&&
&&&&&$$$$$$$$$$$$$$$$$$$$$&&&&&&&$x+;;;;;+x$&&&&&&x;;:.:;&$;.:x&&&&&&$$$$$$$$$$$$$$$$$&&&&
&&&&&&&$$$$$$$$$$$$$$$$$$$$$$&&&&&&&&&&&&&&&&&$XXx:.:;+$$+.:+&&&&$$$$$$$$$$$$$$$$$$&&&&&&&
&&&&&&&&&$$$$$$$$$$$$$$$$$$$$$$$$$&&&&&&&&&&$x;:::;x$&X::;X&&&$$$$$$$$$$$$$$$$$$&&&&&&&&&&
&&&&&&&&&&&$$$$$$$$$$$$$$$$$$$$$$$$$$$x+;;;++xX&&&&+::+$&&&&$$$$$$$$$$$$$$$$$$$&&&&&&&&&&&
&&&&&&&&&&&&&&$$$$$$$$$$$$$$$$$$$$$$$$$$$&&&&&&$X$$&&&&$$$$$$$$$$$$$$$$$$$$$$&&&&&&&&&&&&&

)";
    std::cout << ascii_art;


    set_console_color(con_st, DEFAULT);
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
    model->setThreadCount(8);
    std::string input = "";

    
    

    //main chat loop.
    if (!params.no_interactive && !sighup_received) {
        input = get_input(con_st, input, params);
        //if (input == "")input = get_input(con_st, input, params);

        //Interactive mode. We have a prompt.
        if (params.prompt != "") {
            if (params.use_animation) { stop_display = false; future = std::async(std::launch::async, display_frames); }
            if (params.b_token != "") { answer = answer + params.b_token; if (!params.use_animation) { std::cout << params.b_token; } }
            model->prompt( input , prompt_template,
                prompt_callback, response_callback, recalculate_callback,prompt_context , false, nullptr);
            if (params.e_token != "") { std::cout << params.e_token; answer = answer + params.e_token; }
            if (params.use_animation) { stop_display = true; future.wait(); stop_display = false; }
            if (params.save_log != "") { save_chat_log(params.save_log, (params.prompt + " " + input + params.default_footer).c_str(), answer.c_str()); }

            //Interactive mode. Else get prompt from input.
        }
        else {
            if (params.use_animation) { stop_display = false; future = std::async(std::launch::async, display_frames); }
            if (params.b_token != "") { answer = answer + params.b_token; if (!params.use_animation) { std::cout << params.b_token; } }
            model->prompt(input, prompt_template,
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
            model->prompt(input, prompt_template,
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
        model->prompt(input, prompt_template,
            prompt_callback, response_callback, recalculate_callback, prompt_context, false, nullptr);
        if (params.e_token != "") { std::cout << params.e_token; answer = answer + params.e_token; }
        if (params.use_animation) { stop_display = true; future.wait(); stop_display = false; }
        if (params.save_log != "") { save_chat_log(params.save_log, (params.prompt + params.default_footer).c_str(), answer.c_str()); }
        std::cout << std::endl;
    }


    set_console_color(con_st, DEFAULT);
    return 0;
}




