#include "phoenixcontroller.h"

PhoenixController::PhoenixController(QObject *parent)
    : QObject{parent}
{
    phoenix_databace::initDb();
    m_chatListModel = new ChatListModel(this);
    m_modelList = new ModelList(this);
}

//*---------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*---------------------------------------------------------------------------------------* Read Property *----------------------------------------------------------------------------------------*//
ChatListModel* PhoenixController::chatListModel() const{
    return m_chatListModel;
}

ModelList* PhoenixController::modelList() const{
    return m_modelList;
}
//*-------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//
