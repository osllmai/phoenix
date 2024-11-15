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


class ModelList : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(CurrentModelList *currentModelList READ currentModelList WRITE setCurrentModelList NOTIFY currentModelListChanged)
    Q_PROPERTY(double downloadProgress READ downloadProgress NOTIFY downloadProgressChanged)
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
    explicit ModelList(QObject *parent = nullptr);
    Q_INVOKABLE void downloadRequest(const int index , const QString &directoryPath);
    Q_INVOKABLE void cancelRequest(const int index);
    Q_INVOKABLE void deleteRequest(const int index);
    Q_INVOKABLE void addModel(const QString &directoryPath);

    //*------------------------------------------------------------------------------****************************------------------------------------------------------------------------------*//
    //*-------------------------------------------------------------------------------* QAbstractItemModel interface*------------------------------------------------------------------------------*//
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    //*---------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
    CurrentModelList *currentModelList() const;
    double downloadProgress() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Write Property  *----------------------------------------------------------------------------------------*//
    void setCurrentModelList(CurrentModelList *currentModelList);
    //*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//


    void addModel(const int &id, const double &fileSize ,const int &ramRamrequired, const QString &name, const QString &information, const QString &fileName,
                  const QString &url, const QString &directoryPath, const QString &parameters, const QString &quant, const QString &type, const QString &promptTemplate,
                  const QString &systemPrompt, const QString &icon, const double &downloadPercent, const bool &isDownloading, const bool &downloadFinished);

public slots:
    void handleDownloadProgress(const int index, qint64 bytesReceived, qint64 bytesTotal);
    void handleDownloadFinished(const int index);

signals:
    void currentModelListChanged();
    void downloadProgressChanged();

private:
    QList<Model*> models;
    QList<Download*>downloads;
    CurrentModelList *m_currentModelList;
    double m_downloadProgress;

    void readModelFromJSONFile();
};

#endif // MODELLIST_H
