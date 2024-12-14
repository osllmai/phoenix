#ifndef CURRENTMODELLIST_H
#define CURRENTMODELLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>
#include <QFileInfo>

#include <QAbstractListModel>
#include "model.h"
#include "download.h"


class CurrentModelList : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int size READ size NOTIFY sizeChanged)
    enum ChatlRoles {
        IdRole = Qt::UserRole + 1,
        FileSizeRole,
        RamRamrequiredRole,
        ParametersRole,
        QuantRole,
        TypeRole,
        PromptTemplateRole,
        SystemPromptRole,
        NameRole,
        InformationRole,
        FileNameRole,
        UrlRole,
        DirectoryPathRole,
        IconModelRole,
        DownloadPercentRole,
        IsDownloadingRole,
        DownloadFinishedRole
    };

public:
    explicit CurrentModelList(QObject *parent = nullptr);

    //*------------------------------------------------------------------------------****************************------------------------------------------------------------------------------*//
    //*-------------------------------------------------------------------------------* QAbstractItemModel interface*------------------------------------------------------------------------------*//
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    //*---------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//

    int size() const;
    void addModel( Model *model);
    void deleteModel( Model *model);

signals:
    void sizeChanged();

private:
    QList<Model*> models;
};


#endif // CURRENTMODELLIST_H
