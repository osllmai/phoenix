#ifndef CHATMODEL_H
#define CHATMODEL_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QAbstractListModel>
#include "chatitem.h"
#include "currentresponsemodel.h"

class ChatModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int size READ size NOTIFY sizeChanged)
    Q_PROPERTY(bool isStart READ isStart NOTIFY isStartChanged)
    Q_PROPERTY(CurrentResponseModel *currentResponse READ currentResponse NOTIFY currentResponseChanged)

    enum ChatItemRoles {
        IdRole = Qt::UserRole + 1,
        DateRequestRole,
        ExecutionTimeRole,
        NumberOfTokenRole,
        PromptRole,
        PromptTimeRole,
        NumberPromptRole,
        NumberOfEditPromptRole,
        ResponseRole,
        ResponseTimeRole,
        NumberResponseRole,
        NumberOfRegenerateRole
    };
public:
    explicit ChatModel(const int &parentId,Message* rootMessage, QObject *parent = nullptr);
    // void saveChatItem(int parentId);
    // void addChatItem(int id, QString prompt, QString response);
    int size();
    void updateResponse(const QString &response);
    void setExecutionTime(const int executionTime);
    void setParentId(const int id);
    Q_INVOKABLE void prompt(const QString &promptText);
    Q_INVOKABLE void nextPrompt(const int index, const int numberOfNext);
    Q_INVOKABLE void editPrompt(const int index,const QString &promptText);
    Q_INVOKABLE void nextResponse(const int index, const int numberOfNext);
    Q_INVOKABLE void regenerateResponse(const int index);

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
    bool isStart() const;
    CurrentResponseModel* currentResponse() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//

signals:
    void startPrompt(const QString &prompt);
    void sizeChanged();
    void isStartChanged();
    void newToken(QString token);
    void currentResponseChanged();

public slots:
    void finishedResponnse(const QString &answer);

private:
    Message *root = new Message(-1,"root",true , this);
    QList<ChatItem*> chatItems;
    CurrentResponseModel* m_currentResponse;

    bool m_isStart;
    int m_parentId;

    bool deleteChatItem(const int index);
    QVariant calculationDateRequest(const int currentIndex) const;
    QVariant calculationPromptRequest(const int currentIndex) const;
    QVariant calculationResponseRequest(const int currentIndex) const;
};

#endif // CHATMODEL_H
