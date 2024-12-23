#pragma once

#include <abstractprovider.h>

#include "../../../phoenix/llmodel.h"

class OfflineModel : public AbstractProvider
{
public:
    explicit OfflineModel(QObject *parent = nullptr);
    bool loadModel(const QString &modelPath);
    void unloadModel();

    void prompt(const QString &text) override;

private:
    LLModel::PromptContext prompt_context;
    LLModel* model;
    std::string prompt_template;
    QString answer;
    bool stop;
    bool handleResponse(int32_t token, const std::string &response);
};
