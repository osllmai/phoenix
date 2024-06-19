

# Nerd Studio Local chatbot


## How to build it:

Run cmack:
```cmd
mkdir build
cd build
cmake ..
cmake --build . --parallel
```

Then,
Run chat: 
On Widnows, to run this you must got to below address
```
build/run/debug
```
On Mac,
```cmd
build/run/debug
```
## how to run it:

```
./chat -m {You Path address} -t 4
```
for exmample, On Windows,

```cmd
./chat -m "c:\LLMS\LlamaGPTJ-chat-main\C_QT\ggml-gpt4all-j.bin" -t 4
```

OR on Mac,

```cmd
./chat -m "/Users/uername/LlamaGPTJ-chat-main-main/C_QT/ggml-gpt4all-j.bin" -t 4 
```



`
./chat -h
`

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
