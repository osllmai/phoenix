# Phoenix Local Chatbot

<p align="center">
  <img src="docs/image/Phoenix.png" alt="phoenix Logo" width="380" height="380" style="border: 2px solid yellow;" />
</p>
<br/>



<div style="position: relative; width: 100%; text-align: center;">
    <a href="https://github.com/osllmai/phoenix">
        <img src="https://readme-typing-svg.demolab.com?font=Georgia&size=16&duration=3000&pause=500&multiline=true&width=700&height=100&lines=Phoenix+Local+Chatbot. Copyright+©️+osllm.ai" alt="Typing SVG" style="margin-top: 10px;"/>
    </a>
</div>



## Cloning the Repository and Building the Project 

First, clone the repository and navigate into the project directory:

```bash
git clone https://github.com/osllmai/phoenix.git
cd phoenix 
```

## Downloading the Model File

We recommend creating a `model` folder in the root directory of the project to store the model file:

```bash
mkdir model
```

Download the model file from one of the following links and save it in the `model` folder:

- [Download Llama 3 Instruct Model](https://gpt4all.io/models/gguf/Meta-Llama-3-8B-Instruct.Q4_0.gguf)
- [Download Orca 2 (Medium) Model](https://gpt4all.io/models/gguf/orca-2-7b.Q4_0.gguf)
- (Phi-3 mini 4k instruct Q4)[https://gpt4all.io/models/gguf/Phi-3-mini-4k-instruct.Q4_0.gguf]

*Credit: copyright to gpt4all.io*

## Building the Project

Create a build directory and run CMake to build the project:

```bash
mkdir build  
cd build
cmake ..
cmake --build . --parallel
```

## Running the Chatbot on Windows

Navigate to the debug directory and run the chat executable:

```bash
cd build/run/debug/
./chat
```

When prompted, enter the path to the model file you downloaded:

```bash
c:\LLMS\phoenix\model\Meta-Llama-3-8B-Instruct.Q4_0.gguf
```

Please consider to watch the video tutorial on how to run the chatbot on Windows on youtube:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=vck-OCaiw10" target="_blank">
 <img src="http://img.youtube.com/vi/vck-OCaiw10/mqdefault.jpg" alt="Watch the video" width="240" height="180" border="10" />
</a>


## Running the Chatbot on Mac


Navigate to the bin directory and run the chat executable:

```bash
cd build/bin/
./chat
```

When prompted, enter the path to the model file you downloaded:

```bash
/Users/username/phoenix/model/ggml-gpt4all-j.bin
```

   

```cmd
./chat -h
```

```sh
usage: ./bin/chat [options]

A simple chat program for GPT-J, LLaMA, and MPT models.
You can set specific initial prompt with the -p flag.
Runs default in interactive and continuous mode.
Type '/reset' to reset the chat context.
Type '/save','/load' to save network state into a binary file.
Type '/save NAME','/load NAME' to rename saves. Default: --save_name NAME.
Type '/help' to show this help dialog.
Type 'quit', 'exit' or, 'Ctrl+C' to quit.

options:
  -h, --help            show this help message and exit
  -v, --version         show version and license information
  --run-once            disable continuous mode
  --no-interactive      disable interactive mode altogether (uses given prompt only)
  --no-animation        disable chat animation
  --no-saves            disable '/save','/load' functionality
  -s SEED, --seed SEED  RNG seed for --random-prompt (default: -1)
  -t N, --threads    N  number of threads to use during computation (default: 4)
  -p PROMPT, --prompt PROMPT
                        prompt to start generation with (default: empty)
  --random-prompt       start with a randomized prompt.
  -n N, --n_predict  N  number of tokens to predict (default: 200)
  --top_k            N  top-k sampling (default: 40)
  --top_p            N  top-p sampling (default: 0.9)
  --temp             N  temperature (default: 0.9)
  --n_ctx            N  number of tokens in context window (default: 0)
  -b N, --batch_size N  batch size for prompt processing (default: 20)
  --repeat_penalty   N  repeat_penalty (default: 1.1)
  --repeat_last_n    N  last n tokens to penalize  (default: 64)
  --context_erase    N  percent of context to erase  (default: 0.8)
  --b_token             optional beginning wrap token for response (default: empty)
  --e_token             optional end wrap token for response (default: empty)
  -j,   --load_json FNAME
                        load options instead from json at FNAME (default: empty/no)
  --load_template   FNAME
                        load prompt template from a txt file at FNAME (default: empty/no)
  --save_log        FNAME
                        save chat log to a file at FNAME (default: empty/no)
  --load_log        FNAME
                        load chat log from a file at FNAME (default: empty/no)
  --save_dir        DIR
                        directory for saves (default: ./saves)
  --save_name       NAME
                        save/load model state binary at save_dir/NAME.bin (current: model_state)
                        context is saved to save_dir/NAME.ctx (current: model_state)
  -m FNAME, --model FNAME
                        model path (current: ./models/ggml-vicuna-13b-1.1-q4_2.bin)
```

```

     .----------------.  .----------------.  .----------------.  .-----------------. .----------------.  .----------------. 
    | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
    | |   ______     | || |  ____  ____  | || |     ____     | || | ____  _____  | || |     _____    | || |  ____  ____  | |
    | |  |_   __ \   | || | |_   ||   _| | || |   .'    `.   | || ||_   \|_   _| | || |    |_   _|   | || | |_  _||_  _| | |
    | |    | |__) |  | || |   | |__| |   | || |  /  .--.  \  | || |  |   \ | |   | || |      | |     | || |   \ \  / /   | |
    | |    |  ___/   | || |   |  __  |   | || |  | |    | |  | || |  | |\ \| |   | || |      | |     | || |    > `' <    | |
    | |   _| |_      | || |  _| |  | |_  | || |  \  `--'  /  | || | _| |_\   |_  | || |     _| |_    | || |  _/ /'`\ \_  | |
    | |  |_____|     | || | |____||____| | || |   `.____.'   | || ||_____|\____| | || |    |_____|   | || | |____||____| | |
    | |              | || |              | || |              | || |              | || |              | || |              | |
    | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
     '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
```





## License

This project is licensed under the MIT [License](https://github.com/kuvaus/LlamaGPTJ-chat/blob/main/LICENSE)
