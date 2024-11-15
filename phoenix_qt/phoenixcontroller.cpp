#include "phoenixcontroller.h"


#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

PhoenixController::PhoenixController(QObject *parent)
    : QObject{parent},m_chatListModel(new ChatListModel(this)), m_modelList(new ModelList(this))
{}

//*---------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*---------------------------------------------------------------------------------------* Read Property *----------------------------------------------------------------------------------------*//
ChatListModel* PhoenixController::chatListModel() const{
    return m_chatListModel;
}

ModelList* PhoenixController::modelList() const{
    return m_modelList;
}
//*-------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//
