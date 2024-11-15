#ifndef CHATMODEL_H
#define CHATMODEL_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QAbstractListModel>
#include "chatitem.h"

class ChatModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int size READ size NOTIFY sizeChanged)

    enum ChatItemRoles {
        IdRole = Qt::UserRole + 1,
        PromptRole,
        NumberPromptRole,
        NumberOfEditPromptRole,
        ResponseRole,
        NumberResponseRole,
        NumberOfRegenerateRole
    };
public:
    explicit ChatModel(QObject *parent = nullptr);
    // void saveChatItem(int parentId);
    // void addChatItem(int id, QString prompt, QString response);
    int size();

    //*-------------------------------------------------------------------------------****************************------------------------------------------------------------------------------*//
    //*-------------------------------------------------------------------------------* QAbstractItemModel interface  *------------------------------------------------------------------------------*//
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    //*-----------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
    int size() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


    Q_INVOKABLE void prompt(const QString &promptText);
    Q_INVOKABLE void nextPrompt(const int index, const int numberOfNext);
    Q_INVOKABLE void editPrompt(const int index,const QString &promptText);
    Q_INVOKABLE void nextResponse(const int index, const int numberOfNext);
    Q_INVOKABLE void regenerateResponse(const int index);
    void updateResponse(const QString &response);

signals:
    void startPrompt(const QString &prompt);
    void sizeChanged();

public slots:

private:
    Message *root = new Message(-1,"root",true , this);
    QList<ChatItem*> chatItems;

    bool deleteChatItem(const int index);
};

#endif // CHATMODEL_H
