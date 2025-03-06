#ifndef CONVERSATIONLIST_H
#define CONVERSATIONLIST_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QAbstractListModel>

#include "conversation.h"
#include "model/model.h"

class ConversationList: public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
public:
    static ConversationList* instance(QObject* parent);
    void readDB();

    enum ConversationRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        DescriptionRole,
        DateRole,
        ModelSettingsRole,
        IsLoadModelRole,
        loadModelInProgressRole,
        ResponseInProgressRole,
        MessageListRole,
        PinnedRole,
        IconRole,
        ConversationObjectRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Q_INVOKABLE void addRequest(/*Model *model, */const QString &firstPrompt);
    Q_INVOKABLE void deleteRequest(const int id);
    Q_INVOKABLE void pinnedRequest(const int id, const bool isPinned);
    Q_INVOKABLE void editTitleRequest(const int id, const QString &title);

public slots:
    void addConversation(const int id, const QString &title, const QString &description, const QDateTime date, const QString &icon,
                  const bool isPinned, const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                  const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                  const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                  const int &contextLength, const int &numberOfGPULayers);

signals:
    void countChanged();
    void requestInsertConversation(const QString &title, const QString &description, const QDateTime date, const QString &icon,
                            const bool isPinned, const bool stream, const QString &promptTemplate, const QString &systemPrompt,
                            const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                            const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                            const int &contextLength, const int &numberOfGPULayers);
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

private:
    explicit ConversationList(QObject* parent);
    static ConversationList* m_instance;

    QList<Conversation*> m_conversations;

    Conversation* findConversationById(const int id);
    QVariant dateCalculation(const QDateTime date)const;
};

#endif // CONVERSATIONLIST_H
