# Linux engine (`applocal_provider`) — llama.cpp backend

A Linux build of the on-device engine. Same stdin/stdout wire protocol as the
Windows `applocal_provider.exe` (`__LoadingModel__Finished__` / `__PROMPT__` /
`__END__` / `__DONE_PROMPTPROCESS__`), so `phoenix_core`'s `SubprocessEngine`
drives it unchanged. Backend is plain llama.cpp (CPU), not gpt4all-backend.

## Build

```bash
# 1. Build llama.cpp shared libs (clang avoids ggml's clang-only warning flags)
git clone --depth 1 https://github.com/ggml-org/llama.cpp.git
cmake -S llama.cpp -B llama.cpp/build -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
  -DBUILD_SHARED_LIBS=ON -DLLAMA_CURL=OFF \
  -DLLAMA_BUILD_EXAMPLES=OFF -DLLAMA_BUILD_TESTS=OFF \
  -DLLAMA_BUILD_TOOLS=OFF -DLLAMA_BUILD_SERVER=OFF
cmake --build llama.cpp/build -j --target llama ggml ggml-cpu

# 2. Build the engine
cmake -S . -B build -DLLAMA_CPP_DIR=$PWD/../../../llama.cpp
cmake --build build

# 3. Stage the shared libs next to the binary (rpath is $ORIGIN)
cp llama.cpp/build/bin/lib{llama,ggml,ggml-base,ggml-cpu}.so build/applocal_provider* .
```

Apt deps: `cmake ninja-build clang pkg-config`.

## Run

```bash
./applocal_provider --model /path/to/model.gguf
```

The app finds it via `PHOENIX_ENGINE_DIR` (Flutter) / `PHOENIX_ENGINE_PATH` (gateway).
