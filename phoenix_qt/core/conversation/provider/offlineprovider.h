#ifndef OFFLINEPROVIDER_H
#define OFFLINEPROVIDER_H

#include "provider.h"
#include <QThread>
#include <QDebug>

class OfflineProvider : public  Provider
{
    Q_OBJECT
public:
    OfflineProvider(QObject* parent = nullptr);
    virtual ~OfflineProvider();

public slots:
    void prompt(const QString &input) override;
    void stop() override;
    void loadModel(const QString &model, const QString &key) override;
    void unLoadModel() override;

private:
    QThread chatLLMThread;
    std::atomic<bool> _stopFlag;

    std::string answer = "";
    // LLModel::PromptContext prompt_context;
    // LLModel* model;
    std::string prompt_template;

    bool handleResponse(int32_t token, const std::string &response);
};

#endif // OFFLINEPROVIDER_H
