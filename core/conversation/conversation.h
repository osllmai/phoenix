#ifndef CONVERSATION_H
#define CONVERSATION_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

#include "./chat/modelsettings.h"
#include "./chat/messagelist.h"
#include "../model/model.h"
#include "./chat/responselist.h"
#include "../model/offline/offlinemodellist.h"
#include "../model/online/onlinemodellist.h"
#include "../provider/provider.h"

class Conversation : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString description READ description NOTIFY descriptionChanged)
    Q_PROPERTY(QDateTime date READ date NOTIFY dateChanged)
    Q_PROPERTY(QString icon READ icon NOTIFY iconChanged)
    Q_PROPERTY(bool isPinned READ isPinned WRITE setIsPinned NOTIFY isPinnedChanged)
    Q_PROPERTY(bool isLoadModel READ isLoadModel WRITE setIsLoadModel NOTIFY isLoadModelChanged)
    Q_PROPERTY(bool loadModelInProgress READ loadModelInProgress WRITE setLoadModelInProgress NOTIFY loadModelInProgressChanged)
    Q_PROPERTY(bool responseInProgress READ responseInProgress WRITE setResponseInProgress NOTIFY responseInProgressChanged)
    Q_PROPERTY(MessageList *messageList READ messageList NOTIFY messageListChanged)
    Q_PROPERTY(Model *model READ model NOTIFY modelChanged)
    Q_PROPERTY(ModelSettings *modelSettings READ modelSettings NOTIFY modelSettingsChanged)
    Q_PROPERTY(ResponseList *responseList READ responseList NOTIFY responseListChanged)

public:
    explicit Conversation(QObject* parent = nullptr) : QObject(parent), m_model(new Model(this)), m_modelSettings(new ModelSettings(1,this)),m_messageList(new MessageList(this)),
        m_responseList(new ResponseList(this)), m_responseInProgress(false) {}
    explicit Conversation(int id, const QString &title, const QString &description, const QString &icon,
                          const QDateTime &date, const bool isPinned, QObject *parent = nullptr);
    explicit Conversation(int id, const QString &title, const QString &description, const QString &icon,
                          const QDateTime &date, const bool isPinned,
                          const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                          const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                          const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                          const int &contextLength, const int &numberOfGPULayers, QObject *parent = nullptr);
    virtual ~Conversation();

    Q_INVOKABLE void readMessages();
    Q_INVOKABLE void prompt(const QString &input, const int idModel);
    Q_INVOKABLE void stop();
    Q_INVOKABLE void loadModel(const int id);
    Q_INVOKABLE void unloadModel();

    void likeMessageRequest( const int messageId, const int like);

    void addMessage(const int id, const QString &text, QDateTime date, const QString &icon, bool isPrompt, const int like);

    const int id() const;

    const QString& title() const;
    void setTitle(const QString &title);

    const QString& description() const;
    void setDescription(const QString &description);

    const QDateTime date() const;
    void setDate(QDateTime date);

    const QString icon() const;
    void setIcon(const QString &icon);

    const bool isPinned() const;
    void setIsPinned(bool isPinned);

    const bool isLoadModel() const;
    void setIsLoadModel(bool isLoadModel);

    const bool loadModelInProgress() const;
    void setLoadModelInProgress(bool inProgress);

    const bool responseInProgress() const;
    void setResponseInProgress(bool inProgress);

    MessageList *messageList();

    Model *model();
    void setModel(Model *model);

    ModelSettings *modelSettings();

    ResponseList *responseList() const;

public slots:
    void loadModelResult(const bool result, const QString &warning);
    void tokenResponse(const QString &token);
    void finishedResponse(const QString &warning);
    void updateModelSettingsConversation();

signals:
    void titleChanged();
    void descriptionChanged();
    void dateChanged();
    void iconChanged();
    void isPinnedChanged();
    void isLoadModelChanged();
    void loadModelInProgressChanged();
    void responseInProgressChanged();
    void messageListChanged();
    void modelChanged();
    void modelSettingsChanged();
    void responseListChanged();
    void conversationChange();

    void requestReadMessages(const int conversationId);
    void requestInsertMessage(const int conversationId, const QString &text, const QString &icon, bool isPrompt, const int like);
    void requestUpdateTextMessage(const int conversationId, const int messageId, const QString &text);
    void requestUpdateDescriptionText(const int conversationId, const QString &text);
    void requestUpdateDateConversation(const int id, const QString &description, const QString &icon);
    void requestUpdateModelSettingsConversation(const int id, const bool &stream,
                                     const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                     const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                     const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                     const int &contextLength, const int &numberOfGPULayers);
    void requestLoadModel(const QString &model, const QString &key);
    void requestUnLoadModel();
    void requestStop();

private:
    int m_id;
    QString m_title;
    QString m_description;
    QDateTime m_date;
    QString m_icon;
    bool m_isPinned;
    bool m_isLoadModel;
    bool m_loadModelInProgress;
    bool m_responseInProgress;
    MessageList *m_messageList;
    Model *m_model;
    ModelSettings *m_modelSettings;
    ResponseList *m_responseList;
    Provider *m_provider;
};

#endif // CONVERSATION_H
