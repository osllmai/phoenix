#pragma once

#include <cstdlib>
#include <iostream>
#include <string>

struct GenParams {
    std::string model;
    int ctx_size = 4096;
    int n_gpu_layers = 0;
    int n_predict = 512;
    int top_k = 40;
    float top_p = 0.95f;
    float min_p = 0.05f;
    float temp = 0.7f;
    float repeat_penalty = 1.1f;
    int repeat_last_n = 64;
    int n_batch = 512;
    bool stream = true;
    std::string system_prompt;
};

inline bool parse_args(int argc, char** argv, GenParams& p) {
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--model" && i + 1 < argc) p.model = argv[++i];
        else if (a == "--ctx-size" && i + 1 < argc) p.ctx_size = std::atoi(argv[++i]);
        else if (a == "--gpu-layers" && i + 1 < argc) p.n_gpu_layers = std::atoi(argv[++i]);
        else { std::cerr << "Unknown argument: " << a << "\n"; return false; }
    }
    if (p.model.empty()) { std::cerr << "--model is required\n"; return false; }
    return true;
}

inline void apply_param(GenParams& p, const std::string& line) {
    const auto pos = line.find('=');
    if (pos == std::string::npos) return;
    const std::string k = line.substr(0, pos);
    const std::string v = line.substr(pos + 1);
    if (k == "stream") p.stream = (v == "true" || v == "1");
    else if (k == "system_prompt") p.system_prompt = v;
    else if (k == "n_predict") p.n_predict = std::atoi(v.c_str());
    else if (k == "top_k") p.top_k = std::atoi(v.c_str());
    else if (k == "top_p") p.top_p = std::atof(v.c_str());
    else if (k == "min_p") p.min_p = std::atof(v.c_str());
    else if (k == "temp") p.temp = std::atof(v.c_str());
    else if (k == "repeat_penalty") p.repeat_penalty = std::atof(v.c_str());
    else if (k == "repeat_last_n") p.repeat_last_n = std::atoi(v.c_str());
    else if (k == "n_batch") p.n_batch = std::atoi(v.c_str());
}
