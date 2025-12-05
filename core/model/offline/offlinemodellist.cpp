#include "offlinemodellist.h"

#include "../../conversation/conversationlist.h"

OfflineModelList* OfflineModelList::m_instance = nullptr;

OfflineModelList* OfflineModelList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new OfflineModelList(parent);
        qInfo() << "[Init] OfflineModelList instance created.";
    }
    return m_instance;
}

OfflineModelList::OfflineModelList(QObject* parent)
    : m_downloadProgress(0), QAbstractListModel(parent)
{
#if defined(Q_OS_WIN)
    qInfo() << "[Platform] Running on Windows";
#elif defined(Q_OS_MAC)
    qInfo() << "[Platform] Running on macOS";
#elif defined(Q_OS_LINUX)
    qInfo() << "[Platform] Running on Linux";
#else
    qInfo() << "[Platform] Unknown OS";
#endif

    connect(&m_sortWatcher, &QFutureWatcher<QList<OfflineModel*>>::finished,
            this, &OfflineModelList::handleSortingFinished);
}

int OfflineModelList::count() const{return m_models.count();}

int OfflineModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_models.count();
}

QVariant OfflineModelList::data(const QModelIndex &index, int role = Qt::DisplayRole) const{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_models.count())
        return QVariant();

    OfflineModel* model = m_models[index.row()];

    switch (role) {
    case IdRole:
        return model->id();
    case NameRole:
        return model->name();
    case ModelNameRole:
        return model->modelName();
    case KeyRole:
        return model->key();
    case InformationRole:
        return model->information();
    case IconRole:
        return model->icon();
    case CompanyRole:
        return QVariant::fromValue(m_models[index.row()]->company());
    case IsLikeRole:
        return model->isLike();
    case AddModelTimeRole:
        return model->addModelTime();
    case FileSizeRole:
        return model->fileSize();
    case RamRamrequiredRole:
        return model->ramRamrequired();
    case ParametersRole:
        return model->parameters();
    case QuantRole:
        return model->quant();
    case DownloadFinishedRole:
        return model->downloadFinished();
    case IsDownloadingRole:
        return model->isDownloading();
    case DownloadPercentRole:
        return model->downloadPercent();
    case TypeRole:
        return model->type();
    case ModelObjectRole:
        return QVariant::fromValue(m_models[index.row()]);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> OfflineModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[ModelNameRole] = "modelName";
    roles[KeyRole] = "key";
    roles[InformationRole] = "information";
    roles[IconRole] = "icon";
    roles[CompanyRole] = "company";
    roles[IsLikeRole] = "isLike";
    roles[AddModelTimeRole] = "addModelTime";
    roles[FileSizeRole] = "fileSize";
    roles[RamRamrequiredRole] = "ramRamrequired";
    roles[ParametersRole] = "parameters";
    roles[QuantRole] = "quant";
    roles[DownloadFinishedRole] = "downloadFinished";
    roles[IsDownloadingRole] = "isDownloading";
    roles[DownloadPercentRole] = "downloadPercent";
    roles[TypeRole] = "type";
    roles[ModelObjectRole] = "modelObject";
    return roles;
}

bool OfflineModelList::setData(const QModelIndex &index, const QVariant &value, int role) {
    OfflineModel* model = m_models[index.row()]; // The person to edit
    bool somethingChanged{false};

    switch (role) {
    case IsLikeRole:
        if( model->isLike()!= value.toBool()){
            model->setIsLike(value.toBool());
            somethingChanged = true;
        }
        break;
    }
    if(somethingChanged){
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

void OfflineModelList::finalizeSetup(){
    setFinishedSetup(true);
    sortAsync(NameRole , Qt::AscendingOrder);
}

void OfflineModelList::sortAsync(int role, Qt::SortOrder order) {
    if (m_models.isEmpty()) return;

    auto modelsCopy = m_models;
    QFuture<QList<OfflineModel*>> future = QtConcurrent::run([modelsCopy, role, order]() mutable {
        QCollator collator;
        collator.setNumericMode(true);
        std::sort(modelsCopy.begin(), modelsCopy.end(), [&](OfflineModel* a, OfflineModel* b) {
            QString sa, sb;
            if (role == NameRole) {
                sa = a->name();
                sb = b->name();
            } else if (role == ModelNameRole) {
                sa = a->modelName();
                sb = b->modelName();
            }
            return (order == Qt::AscendingOrder)
                       ? (collator.compare(sa, sb) < 0)
                       : (collator.compare(sa, sb) > 0);
        });
        return modelsCopy;
    });

    m_sortWatcher.setFuture(future);
}

void OfflineModelList::handleSortingFinished() {
    beginResetModel();
    m_models = m_sortWatcher.result();
    endResetModel();
    emit sortingFinished();
}

OfflineModel* OfflineModelList::at(int index) const{
    if (index < 0 || index >= m_models.count())
        return nullptr;
    return m_models.at(index);
}

double OfflineModelList::downloadProgress() const{return m_downloadProgress;}

void OfflineModelList::likeRequest(const int id, const bool isLike){
    emit requestUpdateIsLikeModel(id, isLike);
}

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

void OfflineModelList::addModel(Company* company, const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                                const QString& parameters, const QString& quant, const double downloadPercent,
                                const bool isDownloading, const bool downloadFinished,

                                const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                                const bool isLike, const QString& type, const BackendType backend,
                                const QString& icon , const QString& information , const QString& promptTemplate ,
                                const QString& systemPrompt, QDateTime expireModelTime, const bool recommended ,
                                const QString &currentFolder)
{
    if(finishedSetup()){
        const int index = m_models.size();
        beginInsertRows(QModelIndex(), index, index);
    }
    OfflineModel* model = new OfflineModel(company, fileSize, ramRamrequired, fileName, url, parameters,
                                           quant, downloadPercent, isDownloading, downloadFinished,

                                           id, "localModel/"+modelName, name, key, addModelTime, isLike, type, backend, icon, information,
                                           promptTemplate, systemPrompt, expireModelTime, recommended, m_instance);

    m_models.append(model);

    if(finishedSetup()){
        endInsertRows();
        emit countChanged();

        if(currentFolder != ""){
            downloadRequest(id, currentFolder);
        }
    }
}

OfflineModel* OfflineModelList::findModelById(int id) {
    auto it = std::find_if(m_models.begin(), m_models.end(), [id](OfflineModel* m) { return m->id() == id; });
    return (it != m_models.end()) ? *it : nullptr;
}

OfflineModel* OfflineModelList::findModelByModelName(const QString modelName){
    for (OfflineModel* model : m_models) {
        if (model->modelName() == modelName) {
            return model;
        }
    }
    return nullptr;
}

OfflineModel* OfflineModelList::existModelByFileName(const QString fileName){
    for (OfflineModel* model : m_models) {
        if (model->fileName() == fileName) {
            return model;
        }
    }
    return nullptr;
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

int OfflineModelList::numberDownload() const{return m_numberDownload;}
void OfflineModelList::setNumberDownload(int newNumberDownload){
    if (m_numberDownload == newNumberDownload)
        return;
    m_numberDownload = newNumberDownload;
    qInfo()<<newNumberDownload;
    emit numberDownloadChanged();
}

bool OfflineModelList::finishedSetup() const{return m_finishedSetup;}
void OfflineModelList::setFinishedSetup(bool newFinishedSetup){
    if (m_finishedSetup == newFinishedSetup)
        return;
    m_finishedSetup = newFinishedSetup;
    emit finishedSetupChanged();
}
