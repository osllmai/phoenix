#ifndef HUGGINGFACEMODELLIST_H
#define HUGGINGFACEMODELLIST_H

#include <QAbstractListModel>
#include <QList>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QThread>
#include <QDebug>
#include <QtConcurrent>
#include <QStandardPaths>
#include <QFile>
#include <QDir>

#include "./huggingfacemodel.h"
#include "./huggingfacemodelinfo.h"

class HuggingfaceModelList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(HuggingfaceModelInfo* hugginfaceInfo READ hugginfaceInfo NOTIFY hugginfaceInfoChanged FINAL)

public:
    static HuggingfaceModelList* instance(QObject* parent);

    Q_INVOKABLE void fetchModels();
    Q_INVOKABLE void loadMore(int count = 5);
    Q_INVOKABLE void OpenModel(QString id);
    Q_INVOKABLE void CloseModel(QString id);

    enum HuggingfaceModelRoles {
        IdRole = Qt::UserRole + 1,
        IdModelRole,
        NameRole,
        IconRole,
        LikesRole,
        DownloadsRole,
        PiplineTagRole,
        LibraryNameRole,
        TagsRole,
        CreatedAtRole,
        ModelObjectRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    // bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    HuggingfaceModelInfo* hugginfaceInfo();

signals:
    void countChanged();
    void hugginfaceInfoChanged();
    void requestAddModel(const QString &name, const QString &url, const QString& type,
                  const QString &companyName, const QString &companyIcon);

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    explicit HuggingfaceModelList(QObject* parent);
    static HuggingfaceModelList* m_instance;

    QList<HuggingfaceModel*> m_models;
    QList<HuggingfaceModel*> remainingModels;
    QNetworkAccessManager *m_manager;

    HuggingfaceModelInfo* m_hugginfaceInfo = nullptr;

    QString cacheFilePath() const;
    void processJson(const QByteArray &rawData);
};

#endif // HUGGINGFACEMODELLIST_H
