#include "offlineprovider.h"

#include <QCoreApplication>

OfflineProvider::OfflineProvider(QObject* parent)
    : Provider(parent), _stopFlag(false)
{}

OfflineProvider::OfflineProvider(QObject *parent, const QString &model, const QString &key)
    : Provider(parent), _stopFlag(false), m_model(key)
{
    qCDebug(logOfflineProvider) << "OfflineProvider created with model:" << model << "key:" << key;
}

OfflineProvider::~OfflineProvider() {
    _stopFlag = true;
    if (m_process) {
        m_process->kill();
        m_process->deleteLater();
    }
    qCInfo(logOfflineProvider) << "delete Offline provider";
}

void OfflineProvider::stop() {
    _stopFlag = true;
}

void OfflineProvider::loadModel(const QString &model, const QString &key) {
    qCInfo(logOfflineProvider) << "Loading model with key:" << key;

    QThread::create([this, key]() {
        m_process = new QProcess;
        m_process->setProcessChannelMode(QProcess::MergedChannels);
        m_process->setReadChannel(QProcess::StandardOutput);

#if defined(Q_OS_WIN)
        QString exeFile = "applocal_provider.exe";
#elif defined(Q_OS_MAC)
        QString exeFile = "applocal_provider";
#else
        QString exeFile = "applocal_provider";
#endif

        QString exePath = QString::fromUtf8(APP_PATH) + "/" + exeFile;
        QStringList arguments{ "--model", key };

#if defined(Q_OS_LINUX)
        QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
        QString currentPath = env.value("LD_LIBRARY_PATH");
        env.insert("LD_LIBRARY_PATH",
                   QString::fromUtf8(APP_PATH) +
                       (currentPath.isEmpty() ? "" : ":" + currentPath));
        m_process->setProcessEnvironment(env);

#elif defined(Q_OS_MAC)
        QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

        QString defaultPath =
            "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:"
            "/Library/Apple/usr/bin:/Applications/Xcode.app/Contents/Developer/usr/bin";
        QString defaultLibPath =
            "/usr/local/lib:/opt/homebrew/lib:/System/Library/Frameworks:/Library/Frameworks";

        QString appPath = QString::fromUtf8(APP_PATH);
        QString currentPath = env.value("PATH");
        QString currentLibPath = env.value("DYLD_LIBRARY_PATH");

        env.insert("PATH",
                   QString("%1:%2:%3")
                       .arg(appPath)
                       .arg(defaultPath)
                       .arg(currentPath));

        env.insert("DYLD_LIBRARY_PATH",
                   QString("%1:%2:%3")
                       .arg(appPath)
                       .arg(defaultLibPath)
                       .arg(currentLibPath));

        env.insert("HOME", QDir::homePath());
        env.insert("PWD", QDir::currentPath());
        env.insert("TMPDIR", QDir::tempPath());
        env.insert("LANG", "en_US.UTF-8");
        env.insert("LC_ALL", "en_US.UTF-8");
        env.insert("SHELL", "/bin/zsh");
        env.insert("USER", qEnvironmentVariable("USER"));
        env.insert("LOGNAME", qEnvironmentVariable("LOGNAME"));
        env.insert("TERM", "xterm-256color");
        env.insert("TERM_PROGRAM", "Apple_Terminal");
        env.insert("TERM_SESSION_ID", "qt_simulated_session");

        env.insert("GGML_METAL_PATH_RESOURCES", appPath);
        env.insert("GGML_METAL_DEVICE", "auto");
        env.insert("GGML_METAL_TUNER_PATH", QDir::tempPath() + "/ggml-metal-tuners");
        env.insert("GGML_METAL_ENABLE_LOGGING", "1");

        env.insert("XPC_FLAGS", "0x0");
        env.insert("XPC_SERVICE_NAME", "0");
        env.insert("__CFBundleIdentifier", "com.qt.offlineprovider");
        env.insert("CFPROCESS_PATH", appPath);
        env.insert("CFLOG_FORCE_STDERR", "YES");

        {
            QProcess sysInfo;
            sysInfo.start("/usr/sbin/system_profiler", {"SPHardwareDataType"});
            sysInfo.waitForFinished(2000);
            QString hw = QString::fromUtf8(sysInfo.readAllStandardOutput()).trimmed();
            env.insert("SYSTEM_HARDWARE_INFO", hw);
        }

        {
            QProcess gpuInfo;
            gpuInfo.start("/usr/sbin/system_profiler", {"SPDisplaysDataType"});
            gpuInfo.waitForFinished(2000);
            QString gpu = QString::fromUtf8(gpuInfo.readAllStandardOutput()).trimmed();
            env.insert("SYSTEM_GPU_INFO", gpu);
        }

        {
            QProcess cpuInfo;
            cpuInfo.start("sysctl", {"-n", "machdep.cpu.brand_string"});
            cpuInfo.waitForFinished(1000);
            QString cpu = QString::fromUtf8(cpuInfo.readAllStandardOutput()).trimmed();
            env.insert("SYSTEM_CPU_BRAND", cpu);
        }

        env.insert("DISPLAY", "/private/tmp/com.apple.launchd.display");
        env.insert("QT_MAC_WANTS_LAYER", "1");

        m_process->setProcessEnvironment(env);

        qCInfo(logOfflineProvider) << "macOS PATH:" << env.value("PATH");
        qCInfo(logOfflineProvider) << "macOS DYLD_LIBRARY_PATH:" << env.value("DYLD_LIBRARY_PATH");
        qCInfo(logOfflineProvider) << "CPU:" << env.value("SYSTEM_CPU_BRAND");
        qCInfo(logOfflineProvider) << "GPU info length:" << env.value("SYSTEM_GPU_INFO").length();
#endif



        state = ProviderState::LoadingModel;
        qCInfo(logOfflineProvider) << "Starting process at:" << exePath << "with arguments:" << arguments;

        connect(this, &OfflineProvider::sendPromptToProcess, this, [this](const QString &promptText, const QString &paramBlock) {
            qCInfo(logOfflineProvider) << "Sending prompt to process. State:" << static_cast<int>(state);
            if (state == ProviderState::WaitingForPrompt || state == ProviderState::SendingPrompt) {
                m_process->write(paramBlock.toUtf8());
                m_process->waitForBytesWritten();

                m_process->write("__PROMPT__\n");
                m_process->waitForBytesWritten();

                m_process->write((promptText.trimmed() + "\n__END__\n").toUtf8());
                m_process->waitForBytesWritten();

                state = ProviderState::ReadingResponse;
            } else {
                qCWarning(logOfflineProvider) << "Cannot send prompt. Invalid state:" << static_cast<int>(state);
            }
        });

        m_process->start(exePath, arguments);
        if (!m_process->waitForStarted()) {
            qCCritical(logOfflineProvider) << "Failed to start process:" << m_process->errorString();
            emit requestFinishedResponse("Failed to start process");
            return;
        }

        qCInfo(logOfflineProvider) << "Process started successfully.";

        while (m_process->state() == QProcess::Running) {
            if (m_process->waitForReadyRead(400)) {
                QByteArray output = m_process->readAllStandardOutput();
                QString outputString = QString::fromUtf8(output);
                qInfo()<< outputString.trimmed();

                if (outputString.trimmed().endsWith("__DONE_PROMPTPROCESS__")) {
                    QString cleanedOutput = outputString.trimmed();
                    QString beforeDone = cleanedOutput.left(cleanedOutput.lastIndexOf("__DONE_PROMPTPROCESS__"));
                    emit requestTokenResponse(beforeDone);

                    state = ProviderState::SendingPrompt;
                    emit requestFinishedResponse("");

                    qCInfo(logOfflineProvider) << "Prompt processing done.";
                }

                switch (state) {
                case ProviderState::LoadingModel: {
                    if (outputString.trimmed().endsWith("__LoadingModel__Finished__")) {
                        qCInfo(logOfflineProvider) << "Model loaded successfully.";
                        state = ProviderState::WaitingForPrompt;

                        if (m_hasPendingPrompt) {
                            qCInfo(logOfflineProvider) << "Sending pending prompt...";
                            QString paramBlock =
                                "__PARAMS_SETTINGS__\n" +
                                QString("stream=%1\n").arg(m_pendingPrompt.stream ? "true" : "false") +
                                QString("prompt_template=%1\n").arg(m_pendingPrompt.promptTemplate) +
                                QString("system_prompt=%1\n").arg(m_pendingPrompt.systemPrompt) +
                                QString("n_predict=%1\n").arg(m_pendingPrompt.maxTokens) +
                                QString("top_k=%1\n").arg(m_pendingPrompt.topK) +
                                QString("top_p=%1\n").arg(m_pendingPrompt.topP) +
                                QString("min_p=%1\n").arg(m_pendingPrompt.minP) +
                                QString("temp=%1\n").arg(m_pendingPrompt.temperature) +
                                QString("n_batch=%1\n").arg(m_pendingPrompt.promptBatchSize) +
                                QString("repeat_penalty=%1\n").arg(m_pendingPrompt.repeatPenalty) +
                                QString("repeat_last_n=%1\n").arg(m_pendingPrompt.repeatPenaltyTokens) +
                                QString("ctx_size=%1\n").arg(m_pendingPrompt.contextLength) +
                                QString("n_gpu_layers=%1\n").arg(m_pendingPrompt.numberOfGPULayers) +
                                "__END_PARAMS_SETTINGS__\n";

                            emit sendPromptToProcess(m_pendingPrompt.input, paramBlock);
                            m_hasPendingPrompt = false;
                        }
                    }
                    break;
                }

                case ProviderState::SendingPrompt:
                    qCInfo(logOfflineProvider) << "Prompt sent. Returning to WaitingForPrompt.";
                    state = ProviderState::WaitingForPrompt;
                    break;

                case ProviderState::ReadingResponse:
                    if (_stopFlag) {
                        m_process->write("__STOP__\n");
                        m_process->waitForBytesWritten();
                        _stopFlag = false;
                        qCInfo(logOfflineProvider) << "Stop flag detected. Sent __STOP__.";
                        state = ProviderState::SendingPrompt;
                    }

                    emit requestTokenResponse(outputString);
                    break;

                default:
                    qCWarning(logOfflineProvider) << "Unhandled state:" << static_cast<int>(state);
                    break;
                }
            }
        }

        m_process->waitForFinished(50);
        _stopFlag = false;
        emit requestFinishedResponse("");

    })->start();
}

// void OfflineProvider::unLoadModel() {
//     _stopFlag = true;
//     if (m_process) {
//         m_process->kill();
//         m_process->deleteLater();
//     }
// }

void OfflineProvider::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                             const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                             const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                             const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers)
{

    qCInfo(logOfflineProvider) << "Prompt called with input:" << input.left(30) << "...";

    PromptRequest request = {
        input, stream, promptTemplate, systemPrompt, temperature, topK,
        topP, minP, repeatPenalty, promptBatchSize, maxTokens,
        repeatPenaltyTokens, contextLength, numberOfGPULayers
    };

    QString paramBlock =
        "__PARAMS_SETTINGS__\n" +
        QString("stream=%1\n").arg(request.stream ? "true" : "false") +
        QString("prompt_template=%1\n").arg(request.promptTemplate) +
        QString("system_prompt=%1\n").arg(request.systemPrompt) +
        QString("n_predict=%1\n").arg(request.maxTokens) +
        QString("top_k=%1\n").arg(request.topK) +
        QString("top_p=%1\n").arg(request.topP) +
        QString("min_p=%1\n").arg(request.minP) +
        QString("temp=%1\n").arg(request.temperature) +
        QString("n_batch=%1\n").arg(request.promptBatchSize) +
        QString("repeat_penalty=%1\n").arg(request.repeatPenalty) +
        QString("repeat_last_n=%1\n").arg(request.repeatPenaltyTokens) +
        QString("ctx_size=%1\n").arg(request.contextLength) +
        QString("n_gpu_layers=%1\n").arg(request.numberOfGPULayers) +
        "__END_PARAMS_SETTINGS__\n";

    if (state == ProviderState::WaitingForPrompt) {
        qCInfo(logOfflineProvider) << "Sending prompt immediately.";
        emit sendPromptToProcess(request.input, paramBlock);
    } else {
        qCInfo(logOfflineProvider) << "System busy. Queuing prompt.";
        m_pendingPrompt = request;
        m_hasPendingPrompt = true;
    }
}
