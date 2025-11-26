#ifndef DEEPSEARCHCONVERSATION_H
#define DEEPSEARCHCONVERSATION_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

#include "../../model/modelsettings.h"
#include "../chat/messagelist.h"
#include "../../model/model.h"
#include "../../model/offline/offlinemodellist.h"
#include "../../model/online/onlinemodellist.h"
#include "../../model/online/onlinecompanylist.h"
#include "../../model/online/onlinecompany.h"
#include "../../provider/provider.h"
#include "../conversation.h"

#include <QLoggingCategory>
#include "logcategories.h"

class DeepSearchConversation : public Conversation
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit DeepSearchConversation(QObject* parent = nullptr)
        : Conversation(parent) {}

    explicit DeepSearchConversation(int id, const QString &title, const QString &description,
                              const QString &icon, const QDateTime &date, const bool isPinned,
                              QObject *parent = nullptr);

    explicit DeepSearchConversation(int id, const QString &title, const QString &description,
                              const QString &icon, const QDateTime &date, const bool isPinned,
                              const bool &stream, const QString &promptTemplate,
                              const QString &systemPrompt, const double &temperature,
                              const int &topK, const double &topP, const double &minP,
                              const double &repeatPenalty, const int &promptBatchSize,
                              const int &maxTokens, const int &repeatPenaltyTokens,
                              const int &contextLength, const int &numberOfGPULayers,
                              QObject *parent = nullptr);

    virtual ~DeepSearchConversation();

    enum class DeepSearchState {
        StartThinking,
        SearchInArxiv,
        PdfTokenizer,
        TopK,
        SendModel,
        Finished
    };

    Q_INVOKABLE void readMessages();
    Q_INVOKABLE void prompt(const QString &input, const QString &fileName, const QString &fileInfo);
    Q_INVOKABLE void stop();
    Q_INVOKABLE void loadModel(const int id);
    Q_INVOKABLE void unloadModel();

    void likeMessageRequest(const int messageId, const int like);

    void addMessage(const int id, const QString &text, const QString &fileName, QDateTime date,
                    const QString &icon, bool isPrompt, const int like);

public slots:
    void loadModelResult(const bool result, const QString &warning);
    void tokenResponse(const QString &token);
    void finishedResponse(const QString &warning);
    void updateModelSettingsConversation();

private:
    // void thinking();
    // void downloadRequest(const int id, QString directoryPath);
    // void tokenizer();
    // void sendPrompt();
};

#endif // DEEPSEARCHCONVERSATION_H
