#ifndef MESSAGELIST_H
#define MESSAGELIST_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QAbstractListModel>

#include "message.h"

class MessageList: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
public:
    explicit MessageList(QObject* parent);

    enum MessageRoles {
        IdRole = Qt::UserRole + 1,
        TextRole,
        DateRole,
        IconRole,
        IsPromptRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

public slots:
    void addMessage(const int id, const QString &text, const QDateTime date, const QString &icon, const bool isPrompt);

signals:
    void countChanged();
    void requestDeleteMessage(const int &id);
    void requestAddMessage(const int id, const QString &text, const QDateTime date, const QString &icon, const bool isPrompt);

private:
    QList<Message*> m_messages;

    Message* findMessageById(const int id);
};

#endif // MESSAGELIST_H
