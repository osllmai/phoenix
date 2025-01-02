#include "currentresponsemodel.h"


CurrentResponseModel::CurrentResponseModel(QObject *parent)
    : QAbstractListModel(parent)
{}

//*------------------------------------------------------------------------------**************************-----------------------------------------------------------------------------*//
//*------------------------------------------------------------------------------* QAbstractItemModel interface *------------------------------------------------------------------------------*//
int CurrentResponseModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return texts.size();
}

QVariant CurrentResponseModel::data(const QModelIndex &index, int role = Qt::DisplayRole) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= texts.count())
        return QVariant();

    //The index is valid
    QString text = texts[index.row()];

    switch (role) {
    case IdRole:
        return index.row();
    case TextRole:
        return text;
    }

    return QVariant();
}

QHash<int, QByteArray> CurrentResponseModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TextRole] = "text";
    return roles;
}

Qt::ItemFlags CurrentResponseModel::flags(const QModelIndex &index) const {
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

bool CurrentResponseModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    QString text = texts[index.row()]; // The person to edit
    bool somethingChanged{false};

    switch (role) {
    case TextRole:
        if( text != value.toString()){
            texts[index.row()] = value.toString();
            somethingChanged = true;
        }
    }
    if(somethingChanged){
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}
//*---------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//

int CurrentResponseModel::size() const{
    return texts.size();
}

void CurrentResponseModel::updateResponse(const QString &token){
    qInfo()<<token;

    const int index = texts.size();
    if(numberOfTokenInLastText<50 && index !=0 ){
        texts[index-1] = texts[index-1]+ token;
        emit dataChanged(createIndex(index-1, 0), createIndex(index-1, 0), {TextRole});
        numberOfTokenInLastText++;
    }else{
        numberOfTokenInLastText = 0;
        beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
        texts.append(token);
        endInsertRows();
    }
}
