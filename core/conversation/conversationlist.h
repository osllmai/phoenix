#ifndef CONVERSATIONLIST_H
#define CONVERSATIONLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>
#include <QRegularExpression>

#include "conversation.h"
#include "model/model.h"

class ConversationList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(Conversation *currentConversation READ currentConversation NOTIFY currentConversationChanged FINAL)
    Q_PROPERTY(Conversation *previousConversation READ previousConversation NOTIFY previousConversationChanged FINAL)
    Q_PROPERTY(bool isEmptyConversation READ isEmptyConversation WRITE setIsEmptyConversation NOTIFY isEmptyConversationChanged FINAL)

    Q_PROPERTY(int modelId READ modelId WRITE setModelId NOTIFY modelIdChanged FINAL)
    Q_PROPERTY(QString modelIcon READ modelIcon NOTIFY modelIconChanged FINAL)
    Q_PROPERTY(QString modelName READ modelName NOTIFY modelNameChanged FINAL)
    Q_PROPERTY(QString modelPromptTemplate READ modelPromptTemplate NOTIFY modelPromptTemplateChanged FINAL)
    Q_PROPERTY(QString modelSystemPrompt READ modelSystemPrompt NOTIFY modelSystemPromptChanged FINAL)
    Q_PROPERTY(bool modelSelect READ modelSelect NOTIFY modelSelectChanged FINAL)

public:
    static ConversationList* instance(QObject* parent);
    void readDB();

    enum ConversationRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        DescriptionRole,
        DateRole,
        PinnedRole,
        IconRole,
        QDateTimeRole,
        ModelSettingsRole,
        IsLoadModelRole,
        loadModelInProgressRole,
        ResponseInProgressRole,
        MessageListRole,
        ConversationObjectRole,
        CurrentResponseRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addRequest(const QString &firstPrompt, const QString &fileName, const QString &fileInfo);
    Q_INVOKABLE void selectCurrentConversationRequest(const int id);
    Q_INVOKABLE void deleteRequest(const int id);
    Q_INVOKABLE void pinnedRequest(const int id, const bool isPinned);
    Q_INVOKABLE void editTitleRequest(const int id, const QString &title);
    Q_INVOKABLE void setModelRequest(const int id, const QString &name,  const QString &icon, const QString &promptTemplate, const QString &systemPrompt);
    Q_INVOKABLE void likeMessageRequest(const int conversationId, const int messageId, const int like);

    Conversation *currentConversation();
    void setCurrentConversation(Conversation *newCurrentConversation);

    Conversation *previousConversation();
    void setPreviousConversation(Conversation *newPreviousConversation);

    bool isEmptyConversation() const;
    void setIsEmptyConversation(bool newIsEmptyConversation);

    int modelId() const;
    void setModelId(int newModelId);

    QString modelIcon() const;
    void setModelIcon(const QString &newModelIcon);

    QString modelName() const;
    void setModelName(const QString &newModelText);

    bool modelSelect() const;
    void setModelSelect(bool newModelSelect);

    QString modelPromptTemplate() const;
    void setModelPromptTemplate(const QString &newModelPromptTemplate);

    QString modelSystemPrompt() const;
    void setModelSystemPrompt(const QString &newModelSystemPrompt);

public slots:
    void addConversation(const int id, const QString &title, const QString &description, const QString &fileName,
                         const QString &fileInfo, const QDateTime date, const QString &icon,
                         const bool isPinned, const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                         const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                         const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                         const int &contextLength, const int &numberOfGPULayers, const bool selectConversation);

    void addMessage(const int conversationId, const int id, const QString &text, const QString &fileName, QDateTime date, const QString &icon, bool isPrompt, const int like);
    void readMessages(const int conversationId);
    void insertMessage(const int conversationId, const QString &text, const QString &fileName, const QString &icon, bool isPrompt, const int like);
    void updateTextMessage(const int conversationId, const int messageId, const QString &text);
    void updateDescriptionText(const int conversationId, const QString &text);
    void updateDateConversation(const int id, const QString &description, const QString &icon);
    void updateModelSettingsConversation(const int id, const bool &stream,
                                         const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                         const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                         const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                         const int &contextLength, const int &numberOfGPULayers);

signals:
    void countChanged();
    void currentConversationChanged();
    void previousConversationChanged();
    void isEmptyConversationChanged();
    void modelIdChanged();
    void modelIconChanged();
    void modelNameChanged();
    void modelSelectChanged();
    void modelPromptTemplateChanged();
    void modelSystemPromptChanged();

    void requestInsertConversation(const QString &title, const QString &description, const QString &fileName,
                                   const QString &fileInfo, const QDateTime date, const QString &icon,
                                   const bool isPinned, const bool stream, const QString &promptTemplate, const QString &systemPrompt,
                                   const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                   const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                   const int &contextLength, const int &numberOfGPULayers, const bool selectConversation);
    void requestDeleteConversation(const int id);
    void requestUpdateDateConversation(const int id, const QString &description, const QString &icon);
    void requestUpdateTitleConversation(const int id, const QString &title);
    void requestUpdateIsPinnedConversation(const int id, const bool isPinned);
    void requestUpdateModelSettingsConversation(const int id, const bool &stream,
                                                const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                                const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                                const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                                const int &contextLength, const int &numberOfGPULayers);
    void requestUpdateFilterList();
    void requestReadConversation();
    void requestUpdateLikeMessage(const int conversationId, const int messageId, const int like);

    void requestReadMessages(const int conversationId);
    void requestInsertMessage(const int conversationId, const QString &text, const QString &fileName, const QString &icon, bool isPrompt, const int like);
    void requestUpdateTextMessage(const int conversationId, const int messageId, const QString &text);

private:
    explicit ConversationList(QObject* parent = nullptr);
    static ConversationList* m_instance;

    QList<Conversation*> m_conversations;

    Conversation* findConversationById(const int id);
    QVariant dateCalculation(const QDateTime date)const;
    Conversation *m_currentConversation;
    Conversation *m_previousConversation;
    bool m_isEmptyConversation;

    int m_modelId = -1;
    QString m_modelIcon;
    QString m_modelName;
    QString m_modelPromptTemplate;
    QString m_modelSystemPrompt;
    bool m_modelSelect;
};

#endif // CONVERSATIONLIST_H
