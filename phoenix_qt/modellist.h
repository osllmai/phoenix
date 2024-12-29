#ifndef MODELLIST_H
#define MODELLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>
#include <QFileInfo>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QVariant>
#include <QVariantMap>
#include <QIODevice>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QMap>

#include <QAbstractListModel>
#include "model.h"
#include "download.h"
#include "currentmodellist.h"
#include "database.h"

class ModelList : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(CurrentModelList *currentModelList READ currentModelList WRITE setCurrentModelList NOTIFY currentModelListChanged)
    Q_PROPERTY(int downloadProgress READ downloadProgress NOTIFY downloadProgressChanged)

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
        DownloadFinishedRole,
        BackendTypeRole,
        ObjectRole
    };

public:
    enum class BackendType {
        LocalModel,
        OnlineProvider
    };
    Q_ENUM(BackendType)

    explicit ModelList(QObject *parent = nullptr);

    Q_INVOKABLE void downloadRequest(int id, const QUrl &url);
    Q_INVOKABLE void setApiKey(int id , const QString &apiKey);
    Q_INVOKABLE void cancelRequest(int id);
    Q_INVOKABLE void deleteRequest(int id);
    Q_INVOKABLE void addModel(const QUrl &url);

    //*------------------------------------------------------------------------------****************************------------------------------------------------------------------------------*//
    //*-------------------------------------------------------------------------------* QAbstractItemModel interface*------------------------------------------------------------------------------*//
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    //*---------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************---------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
    CurrentModelList *currentModelList() const;
    double downloadProgress() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************---------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Write Property  *----------------------------------------------------------------------------------------*//
    void setCurrentModelList(CurrentModelList *currentModelList);
    //*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

    Model *at(int index) const;
public slots:
    void handleDownloadProgress(int index, Model *model, qint64 bytesReceived, qint64 bytesTotal);
    void handleDownloadFinished(int index, Model *model);

signals:
    void currentModelListChanged();
    void downloadProgressChanged();

private:
    QList<Model *> _models;
    QList<Download *> downloads;
    CurrentModelList *m_currentModelList;
    int m_downloadProgress;

    Model *findModelById(int id);

    void readModelFromJSONFile();
    void updateDownloadProgress();
    void deleteDownloadModel(Model *model);
    void loadLocalModelsFromJson(QJsonArray jsonArray);
    void loadOnlineProvidersFromJson(QJsonArray jsonArray);
};

#endif // MODELLIST_H
