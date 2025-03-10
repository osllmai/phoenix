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


## Prerequisites

On Windows and Linux, building Phoenix with full GPU support requires the [Vulkan SDK](https://vulkan.lunarg.com/sdk/home) and the latest [CUDA Toolkit](https://developer.nvidia.com/cuda-downloads).



## Cloning the Repository and Building the Project

First, clone the repository and navigate into the project directory:

```bash
git clone --recurse-submodules https://github.com/osllmai/phoenix.git
cd phoenix 
```

## Downloading the Model File

- [Download Llama 3 Instruct Model](https://gpt4all.io/models/gguf/Meta-Llama-3-8B-Instruct.Q4_0.gguf)
- [Download Orca 2 (Medium) Model](https://gpt4all.io/models/gguf/orca-2-7b.Q4_0.gguf)

_Credit: copyright to gpt4all.io_

## Building the Project

Create a build directory and run CMake to build the project:

```bash
mkdir build  
cd build
cmake ..
cmake --build . 
```

## Running the Chatbot on Windows

Navigate to the debug directory and run the chat executable:

```bash
cd build/bin/
./chat
```

When prompted, enter the path to the model file you downloaded:

```bash
C:\LLMS\phoenix\model\Meta-Llama-3-8B-Instruct.Q4_0.gguf
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
