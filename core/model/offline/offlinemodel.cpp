#include "offlinemodel.h"

OfflineModel::OfflineModel(Company* company, const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                          const QString& parameters, const QString& quant, const double downloadPercent,
                          const bool isDownloading, const bool downloadFinished,

                           const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                           const bool isLike, const QString& type,const BackendType backend,
                           const QString& icon , const QString& information , const QString& promptTemplate ,
                           const QString& systemPrompt, QDateTime expireModelTime,
                           const bool recommended, QObject* parent)
    : Model(id, modelName, name, key, addModelTime, isLike, type, backend, icon, information,
            promptTemplate, systemPrompt, expireModelTime, recommended, parent),
    m_company(company), m_fileSize(fileSize), m_ramRamrequired(ramRamrequired), m_fileName(fileName), m_url(url),
    m_parameters(parameters), m_quant(quant), m_downloadPercent(downloadPercent),
    m_isDownloading(isDownloading), m_downloadFinished(downloadFinished)
{}

OfflineModel::~OfflineModel(){}

Company *OfflineModel::company() const{return m_company;}

const double OfflineModel::fileSize() const{return m_fileSize;}

const int OfflineModel::ramRamrequired() const{return m_ramRamrequired;}

const QString &OfflineModel::fileName() const{return m_fileName;}

const QString &OfflineModel::url() const{return m_url;}

const QString &OfflineModel::parameters() const{return m_parameters;}

const QString &OfflineModel::quant() const{return m_quant;}

double OfflineModel::downloadPercent() const{return m_downloadPercent;}
void OfflineModel::setDownloadPercent(const double downloadPercent){
    if(m_downloadPercent == downloadPercent)
        return;
    m_downloadPercent = downloadPercent;
    emit downloadPercentChanged();
}

bool OfflineModel::isDownloading() const{return m_isDownloading;}
void OfflineModel::setIsDownloading(const bool isDownloading){
    if(m_isDownloading == isDownloading)
        return;
    m_isDownloading = isDownloading;
    emit isDownloadingChanged();
}

bool OfflineModel::downloadFinished() const{return m_downloadFinished;}
void OfflineModel::setDownloadFinished(const bool downloadFinished){
    if(m_downloadFinished == downloadFinished)
        return;

    m_downloadFinished = downloadFinished;
    emit downloadFinishedChanged();
}

qint64 OfflineModel::bytesReceived() const{return m_bytesReceived;}
void OfflineModel::setBytesReceived(const qint64 newBytesReceived){
    if (m_bytesReceived == newBytesReceived)
        return;
    m_bytesReceived = newBytesReceived;
    emit bytesReceivedChanged();

    if(m_bytesTotal != 0)
        setDownloadPercent(static_cast<double>(m_bytesReceived) / static_cast<double>(m_bytesTotal)) ;
}
void OfflineModel::handleBytesReceived(qint64 bytesReceived){setBytesReceived(bytesReceived);}

qint64 OfflineModel::bytesTotal() const{return m_bytesTotal;}
void OfflineModel::setBytesTotal(const qint64 newBytesTotal){
    if (m_bytesTotal == newBytesTotal)
        return;
    m_bytesTotal = newBytesTotal;
    emit bytesTotalChanged();
}
void OfflineModel::handleBytesTotal(qint64 bytesTotal){setBytesTotal(bytesTotal);}
