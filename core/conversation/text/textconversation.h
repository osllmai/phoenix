#ifndef TEXTCONVERSATION_H
#define TEXTCONVERSATION_H

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

class TextConversation : public Conversation
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit TextConversation(QObject* parent = nullptr)
        : Conversation(parent) {}

    explicit TextConversation(int id, const QString &title, const QString &description,
                              const QString &icon, const QDateTime &date, const bool isPinned,
                              QObject *parent = nullptr);

    explicit TextConversation(int id, const QString &title, const QString &description,
                              const QString &icon, const QDateTime &date, const bool isPinned,
                              const bool &stream, const QString &promptTemplate,
                              const QString &systemPrompt, const double &temperature,
                              const int &topK, const double &topP, const double &minP,
                              const double &repeatPenalty, const int &promptBatchSize,
                              const int &maxTokens, const int &repeatPenaltyTokens,
                              const int &contextLength, const int &numberOfGPULayers,
                              QObject *parent = nullptr);

    virtual ~TextConversation();

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

};

#endif // TEXTCONVERSATION_H
