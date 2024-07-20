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

- [Download GGML GPT4ALL J v1.3 Groovy Model](https://gpt4all.io/models/ggml-gpt4all-j-v1.3-groovy.bin)
- [Download GGML GPT4ALL J Model](https://gpt4all.io/models/ggml-gpt4all-j.bin)

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
c:\LLMS\phoenix\model\ggml-gpt4all-j.bin
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
## Useful features
Here are some handy features and details on how to achieve them using command line options.

### Save/load chat log and read output from other apps
By default, the program prints the chat to standard (stdout) output, so if you're including the program into your app, it only needs to read stdout. You can also save the whole chat log to a text file with `--save_log` option. There's an elementary way to remember your past conversation by simply loading the saved chat log with `--load_log` option when you start a new session.

### Run the program once without user interaction
If you only need the program to run once without any user interactions, one way is to set prompt with `-p "prompt"` and using `--no-interactive` and `--no-animation` flags. The program will read the prompt, print the answer, and close.

### Add AI personalities and characters
If you want a personality for your AI, you can change `prompt_template_sample.txt` and use `--load_template` to load the modified file. The only constant is that your input during chat will be put on the `%1` line. Instructions, prompt, response, and everything else can be replaced any way you want. Having different `personality_template.txt` files is an easy way to add different AI characters. With _some_ models, giving both AI and user names instead of `Prompt:` and `Response:`, can make the conversation flow more naturally as the AI tries to mimic a conversation between two people.

### Ability to reset chat context
You can reset the chat at any time during chatting by typing `/reset` in the input field. This will clear the AI's memory of past conversations, logits, and tokens. You can then start the chat from a blank slate without having to reload the whole model again.

### Load all parameters using JSON
You can also fetch parameters from a json file with `--load_json "/path/to/file.json"` flag. Different models might perform better or worse with different input parameters so using json files is a handy way to store and load all the settings at once. The JSON file loader is designed to be simple in order to prevent any external dependencies, and as a result, the JSON file must follow a specific format. Here is a simple example:

```javascript
{"top_p": 1.0, "top_k": 50400, "temp": 0.9, "n_batch": 9}
```
This is useful when you want to store different temperature and sampling settings.

And a more detailed one:
```javascript
{
"top_p": 1.0,
"top_k": 50400,
"temp": 0.9,
"n_batch": 20,
"threads": 12,
"prompt": "Once upon a time",
"load_template": "/path/to/prompt_template_sample.txt",
"model": "/path/to/ggml-gpt4all-j-v1.3-groovy.bin",
"no-interactive": "true"
}
```
This one loads the prompt from the json, uses a specific template, and runs the program once in no-interactive mode so user does not have to press any input.

## License

This project is licensed under the MIT [License](https://github.com/kuvaus/LlamaGPTJ-chat/blob/main/LICENSE)