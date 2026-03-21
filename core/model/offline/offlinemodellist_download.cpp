#include "offlinemodellist.h"

#include "../../conversation/conversationlist.h"

void OfflineModelList::downloadRequest(const int id, QString directoryPath) {
    setNumberDownload(m_numberDownload + 1);

    OfflineModel* model = findModelById(id);
    if (!model) {
        qWarning() << "[DownloadRequest] Invalid model ID:" << id;
        return;
    }

    directoryPath = QUrl(directoryPath).toLocalFile();
    directoryPath = QDir::toNativeSeparators(directoryPath);
    QDir dir(directoryPath);
    if (!dir.exists() && !dir.mkpath(".")) {
        qWarning() << "[DownloadRequest] Cannot create directory:" << directoryPath;
    }

    QFileInfo fi(model->fileName());
    QString cleanFileName = fi.fileName();
    QString fullPath = QDir::toNativeSeparators(dir.filePath(cleanFileName));

    model->setKey(fullPath);
    model->setIsDownloading(true);

    qInfo() << "[DownloadRequest]" << "File:" << cleanFileName << "→" << fullPath;

    Download* download = new Download(id, model->url(), model->key(), this);
    if (downloads.size() < 3) {
        connect(download, &Download::downloadProgress, this, &OfflineModelList::handleDownloadProgress, Qt::QueuedConnection);
        connect(download, &Download::downloadFinished, this, &OfflineModelList::handleDownloadFinished, Qt::QueuedConnection);
        connect(download, &Download::downloadFailed, this, &OfflineModelList::handleDownloadFailed, Qt::QueuedConnection);
        download->downloadModel();
    }
    downloads.append(download);

    emit dataChanged(createIndex(m_models.indexOf(model), 0), createIndex(m_models.indexOf(model), 0), {IsDownloadingRole});
}

void OfflineModelList::handleDownloadProgress(const int id, const qint64 bytesReceived, const qint64 bytesTotal) {
    OfflineModel* model = findModelById(id);
    if (!model) return;

    model->setBytesReceived(bytesReceived);
    model->setBytesTotal(bytesTotal);

    updateDownloadProgress();

    const double percent = (bytesTotal > 0) ? (bytesReceived * 100.0 / bytesTotal) : 0;

    emit dataChanged(createIndex(m_models.indexOf(model), 0), createIndex(m_models.indexOf(model), 0), {DownloadPercentRole});
}

void OfflineModelList::handleDownloadFinished(const int id) {
    setNumberDownload(m_numberDownload - 1);

    OfflineModel* model = findModelById(id);
    if (!model) return;

    model->setIsDownloading(false);
    model->setDownloadFinished(true);
    model->setDownloadPercent(100);

    QCoreApplication::processEvents();

    updateDownloadProgress();
    deleteDownloadModel(id);

    emit requestUpdateKeyModel(model->id(), model->key());
    emit dataChanged(createIndex(m_models.indexOf(model), 0), createIndex(m_models.indexOf(model), 0),
                     {IsDownloadingRole, DownloadFinishedRole, DownloadPercentRole});

    qInfo() << "[DownloadFinished] Model:" << model->name() << "ID:" << id;
}

void OfflineModelList::handleDownloadFailed(const int id, const QString &error) {
    qWarning() << "[DownloadFailed]" << id << ":" << error;
    cancelRequest(id);
}

void OfflineModelList::cancelRequest(const int id) {
    setNumberDownload(m_numberDownload - 1);

    OfflineModel* model = findModelById(id);
    if (!model) return;

    for (auto* dl : downloads)
        if (dl->id() == id)
            dl->cancelDownload();

    model->setIsDownloading(false);
    model->setDownloadFinished(false);
    model->setDownloadPercent(0);

    updateDownloadProgress();
    deleteDownloadModel(id);

    emit dataChanged(createIndex(m_models.indexOf(model), 0),
                     createIndex(m_models.indexOf(model), 0),
                     {DownloadFinishedRole, IsDownloadingRole, DownloadPercentRole});

    qInfo() << "[CancelRequest] Canceled download ID:" << id;
}

void OfflineModelList::deleteRequest(const int id) {
    OfflineModel* model = findModelById(id);
    if (!model) return;

    const int index = m_models.indexOf(model);
    model->setIsDownloading(false);
    model->setDownloadFinished(false);

    if (model->url().isEmpty()) {
        beginRemoveRows(QModelIndex(), index, index);
        m_models.removeAll(model);
        endRemoveRows();
        emit requestDeleteModel(model->id());
        delete model;
    } else if (!model->key().isEmpty()) {
        QFile file(model->key());
        if (file.exists())
            file.remove();
        emit requestUpdateKeyModel(model->id(), "");
    }

    ConversationList::instance(this)->setModelSelect(false);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadFinishedRole, IsDownloadingRole});
    qInfo() << "[DeleteRequest] Removed model ID:" << id;
}

void OfflineModelList::addRequest(const QString directoryPath) {
    QUrl url(directoryPath);
    QString localPath = url.isLocalFile() ? url.toLocalFile() : directoryPath;
    QFileInfo fi(localPath);
    emit requestAddModel(fi.baseName(), localPath);
}

void OfflineModelList::updateDownloadProgress(){
    qint64 totalBytesDownload =0;
    qint64 receivedBytesDownload =0;
    for (auto &&model : m_models){
        for(int searchIndex = 0; searchIndex<downloads.size(); searchIndex++){
            if((downloads[searchIndex]->id() == model->id()) &&
                model->bytesTotal()>=100 &&
                model->bytesReceived()>=10 &&
                model->bytesReceived()< model->bytesTotal() &&
                (static_cast<double>(model->bytesReceived())/static_cast<double>(model->bytesTotal()))>0.0001 &&
                (static_cast<double>(model->bytesReceived())/static_cast<double>(model->bytesTotal()))<1){
                totalBytesDownload += model->bytesTotal();
                receivedBytesDownload += model->bytesReceived();
            }
        }
    }
    if(totalBytesDownload != 0)
        m_downloadProgress = static_cast<double>(receivedBytesDownload)/static_cast<double>(totalBytesDownload);
    else
        m_downloadProgress = 0;

    emit downloadProgressChanged();
}

void OfflineModelList::deleteDownloadModel(const int id) {
    if (downloads.size() > 3) {
        connect(downloads[3], &Download::downloadProgress, this, &OfflineModelList::handleDownloadProgress, Qt::QueuedConnection);
        connect(downloads[3], &Download::downloadFinished, this, &OfflineModelList::handleDownloadFinished, Qt::QueuedConnection);
        downloads[3]->downloadModel();
    }
    for (int i = 0; i < downloads.size(); ++i) {
        if (downloads[i]->id() == id) {
            Download* d = downloads[i];
            downloads.removeAt(i);
            delete d;
            qInfo() << "[DeleteDownloadModel] Removed ID:" << id;
            break;
        }
    }
}
