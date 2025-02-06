#include "offlinemodel.h"

OfflineModel::OfflineModel(QObject *parent): Model(parent){}

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
