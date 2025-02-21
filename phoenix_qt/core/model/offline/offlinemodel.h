#ifndef OFFLINEMODEL_H
#define OFFLINEMODEL_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include "../model.h"

class OfflineModel: public Model
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double fileSize READ fileSize CONSTANT FINAL)
    Q_PROPERTY(int ramRamrequired READ ramRamrequired CONSTANT FINAL)
    Q_PROPERTY(QString fileName READ fileName CONSTANT FINAL)
    Q_PROPERTY(QString url READ url CONSTANT FINAL)
    Q_PROPERTY(QString parameters READ parameters CONSTANT FINAL)
    Q_PROPERTY(QString quant READ quant CONSTANT FINAL)
    Q_PROPERTY(double downloadPercent READ downloadPercent WRITE setDownloadPercent NOTIFY downloadPercentChanged FINAL)
    Q_PROPERTY(bool isDownloading READ isDownloading WRITE setIsDownloading NOTIFY isDownloadingChanged FINAL)
    Q_PROPERTY(bool downloadFinished READ downloadFinished WRITE setDownloadFinished NOTIFY downloadFinishedChanged FINAL)
    Q_PROPERTY(qint64 bytesReceived READ bytesReceived WRITE setBytesReceived NOTIFY bytesReceivedChanged FINAL)
    Q_PROPERTY(qint64 bytesTotal READ bytesTotal WRITE setBytesTotal NOTIFY bytesTotalChanged FINAL)

public:
    explicit OfflineModel(QObject* parent = nullptr) : Model(parent) {}

    explicit OfflineModel(const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                          const QString& parameters, const QString& quant, const double downloadPercent,
                          const bool isDownloading, const bool downloadFinished,
                          const int id, const QString& name, const QString& key, QDateTime addModelTime,
                          const bool isLike, Company* company, const BackendType backend,
                          const QString& icon , const QString& information , const QString& promptTemplate ,
                          const QString& systemPrompt, QDateTime expireModelTime, QObject* parent);

    virtual ~OfflineModel();

    const double fileSize() const;

    const int ramRamrequired() const;

    const QString &fileName() const;

    const QString &url() const;

    const QString &parameters() const;

    const QString &quant() const;

    double downloadPercent() const;
    void setDownloadPercent(const double downloadPercent);

    bool isDownloading() const;
    void setIsDownloading(const bool isDownloading);

    bool downloadFinished() const;
    void setDownloadFinished(const bool downloadFinished);

    qint64 bytesReceived() const;
    void setBytesReceived(qint64 newBytesReceived);

    qint64 bytesTotal() const;
    void setBytesTotal(qint64 newBytesTotal);

signals:
    void downloadPercentChanged();
    void isDownloadingChanged();
    void downloadFinishedChanged();
    void bytesReceivedChanged();
    void bytesTotalChanged();
    void cancelRequest();
    void modelChanged();
    void startRequest(const QString &modelPath);

public slots:
    // void handleDownloadFinished();
    void handleBytesReceived(qint64 bytesReceived);
    void handleBytesTotal(qint64 bytesTotal);

private:
    double m_fileSize;
    int m_ramRamrequired;
    QString m_fileName;
    QString m_url;
    QString m_parameters;
    QString m_quant;
    double m_downloadPercent;
    bool m_isDownloading;
    bool m_downloadFinished;
    qint64 m_bytesReceived;
    qint64 m_bytesTotal;
};

#endif // OFFLINEMODEL_H
