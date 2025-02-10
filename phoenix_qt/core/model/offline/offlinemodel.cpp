#include "offlinemodel.h"

OfflineModel::OfflineModel(const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                          const QString& parameters, const QString& quant, const double downloadPercent,
                          const bool isDownloading, const bool downloadFinished,

                           const int id, const QString& name, const QString& key, QDateTime addModelTime,
                           const bool isLike, Company* company, const BackendType backend,
                           const QString& icon , const QString& information , const QString& promptTemplate ,
                           const QString& systemPrompt, QDateTime expireModelTime, QObject* parent)
    : Model(id, name, key, addModelTime, isLike, company, backend, icon, information,
            promptTemplate, systemPrompt, expireModelTime, parent),
    m_fileSize(fileSize), m_ramRamrequired(ramRamrequired), m_fileName(fileName), m_url(url),
    m_parameters(parameters), m_quant(quant), m_downloadPercent(downloadPercent),
    m_isDownloading(isDownloading), m_downloadFinished(downloadFinished)
{}

OfflineModel::~OfflineModel(){}

const double OfflineModel::fileSize() const{return m_fileSize;}

const int OfflineModel::ramRamrequired() const{return m_ramRamrequired;}

const QString &OfflineModel::fileName() const{return m_fileName;}

const QString &OfflineModel::url() const{return m_url;}

const QString &OfflineModel::parameters() const{return m_parameters;}

const QString &OfflineModel::quant() const{return m_quant;}

const double OfflineModel::downloadPercent() const{return m_downloadPercent;}
void OfflineModel::setDownloadPercent(const double downloadPercent){
    if(m_downloadPercent == downloadPercent)
        return;
    m_downloadPercent = downloadPercent;
    emit downloadPercentChanged(m_downloadPercent);
}

const bool OfflineModel::isDownloading() const{return m_isDownloading;}
void OfflineModel::setIsDownloading(const bool isDownloading){
    if(m_isDownloading == isDownloading)
        return;
    m_isDownloading = isDownloading;
    emit isDownloadingChanged(m_isDownloading);
}

const bool OfflineModel::downloadFinished() const{return m_downloadFinished;}
void OfflineModel::setDownloadFinished(const bool downloadFinished){
    if(m_downloadFinished == downloadFinished)
        return;
    m_downloadFinished = downloadFinished;
    emit downloadFinishedChanged(m_downloadFinished);
}
