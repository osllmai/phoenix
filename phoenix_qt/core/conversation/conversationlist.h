#ifndef CONVERSATIONLIST_H
#define CONVERSATIONLIST_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QAbstractListModel>

#include "conversation.h"

class ConversationList: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
public:
    static ConversationList* instance(QObject* parent);

    enum ConversationRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        DescriptionRole,
        DateRole,
        StreamRole,
        PromptTemplateRole,
        SystemPromptRole,
        TemperatureRole,
        TopKRole,
        TopPRole,
        MinPRole,
        RepeatPenaltyRole,
        PromptBatchSizeRole,
        MaxTokensRole,
        RepeatPenaltyTokensRole,
        ContextLengthRole,
        NumberOfGPULayersRole,
        ConversationObjectRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    // QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

public slots:
    void addConversation(const int id, const QString &title, const QString &description, const QDateTime date, const bool &stream,
                  const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                  const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                  const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                  const int &contextLength, const int &numberOfGPULayers);

signals:
    void countChanged();
    void requestDeleteConversation(const int &id);
    void requestUpdateDateConversation(const int id, const QString &description);
    void requestUpdateTitleConversation(const int id, const QString &title);
    void requestUpdateModelSettingsConversation(const int id, const bool &stream,
                        const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                        const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                        const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                        const int &contextLength, const int &numberOfGPULayers);

private:
    explicit ConversationList(QObject* parent);
    static ConversationList* m_instance;

    QList<Conversation*> m_conversations;

    // Conversation* findConversationById(const int id);
};

#endif // CONVERSATIONLIST_H
