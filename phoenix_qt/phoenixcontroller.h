#ifndef PHOENIXCONTROLLER_H
#define PHOENIXCONTROLLER_H

#include <QObject>
#include <QtQml>

#include "chatlistmodel.h"
#include "download.h"
#include "modellist.h"


class PhoenixController : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(ChatListModel *chatListModel READ chatListModel NOTIFY chatListModelChanged )
    Q_PROPERTY(ModelList *modelList READ modelList NOTIFY modelListChanged )
public:
    explicit PhoenixController(QObject *parent = nullptr);


    //*---------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*---------------------------------------------------------------------------------------* Read Property *----------------------------------------------------------------------------------------*//
    ChatListModel* chatListModel() const;
    ModelList* modelList() const;

    //*-------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//

signals:
    void chatListModelChanged();
    void modelListChanged();

private:
    ChatListModel* m_chatListModel;
    ModelList* m_modelList;
};

#endif // PHOENIXCONTROLLER_H
