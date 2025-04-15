// #include "speechtotext.h"
// #include "whisper.h"
// #include <QFile>
// #include <QDebug>
// #include <vector>

// std::vector<float> load_audio_data(const QString &filePath, int &n_samples) {
//     std::vector<float> audio_data;

//     n_samples = 1000;
//     audio_data.resize(n_samples, 0.5f);
//     return audio_data;
// }

// SpeechToText::SpeechToText(QObject *parent) : QObject(parent) {}

// QString SpeechToText::transcribeAudio(const QString &filePath) {
//     whisper_full_params wparams;
//     // whisper_full_params_default(&wparams);

//     struct whisper_context *ctx = whisper_init_from_file("models/ggml-base.bin");
//     if (!ctx) {
//         return "error load model";
//     }

//     int n_samples = 0;
//     std::vector<float> samples = load_audio_data(filePath, n_samples);

//     if (samples.empty()) {
//         whisper_free(ctx);
//         return "error loading audio file";
//     }

//     int res = whisper_full(ctx, wparams, samples.data(), n_samples);
//     if (res != 0) {
//         whisper_free(ctx);
//         return "error in processing";
//     }

//     QString result;
//     for (int i = 0; i < whisper_full_n_segments(ctx); ++i) {
//         result += QString::fromStdString(whisper_full_get_segment_text(ctx, i)) + "\n";
//     }

//     whisper_free(ctx);
//     return result;
// }
