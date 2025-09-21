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
    Q_PROPERTY(bool noMoreModels READ noMoreModels NOTIFY noMoreModelsChanged FINAL)

public:
    static HuggingfaceModelList* instance(QObject* parent);

    Q_INVOKABLE void fetchModels();
    Q_INVOKABLE void loadMore(int count = 1);
    Q_INVOKABLE void openModel(const QString& id, const QString& name, const QString& icon);
    Q_INVOKABLE void closeModel(QString id);
    Q_INVOKABLE void addModel(const QString &idModel, const QString &fileName, const QString& type,
                                     const QString &companyIcon, const QString &currentFolder);

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

    bool noMoreModels() const;
    void setNoMoreModels(bool newNoMoreModels);

signals:
    void countChanged();
    void hugginfaceInfoChanged();
    void noMoreModelsChanged();
    void requestAddModel(const QString &name, const QString &url, const QString& type,
                  const QString &companyName, const QString &companyIcon, const QString &currentFolder);

public slots:
    void readyModel(const QString &fileName);

private slots:
    void onReplyFinished(QNetworkReply *reply);
    void onModelsReady();

private:
    explicit HuggingfaceModelList(QObject* parent);
    static HuggingfaceModelList* m_instance;

    QList<HuggingfaceModel*> m_models;
    QFutureWatcher<QList<QVariantMap>> m_futureWatcher;
    QList<HuggingfaceModel*> remainingModels;
    QNetworkAccessManager *m_manager;

    HuggingfaceModelInfo* m_hugginfaceInfo = nullptr;
    bool m_noMoreModels = false;

    QString cacheFilePath() const;
    void processJson(const QByteArray &rawData);
};

#endif // HUGGINGFACEMODELLIST_H
