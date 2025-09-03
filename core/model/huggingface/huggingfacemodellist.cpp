#include "huggingfacemodellist.h"

HuggingfaceModelList* HuggingfaceModelList::m_instance = nullptr;

HuggingfaceModelList* HuggingfaceModelList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new HuggingfaceModelList(parent);
    }
    return m_instance;
}

HuggingfaceModelList::HuggingfaceModelList(QObject* parent)
    : QAbstractListModel(parent),
    m_manager(new QNetworkAccessManager(this))
{
    connect(m_manager, &QNetworkAccessManager::finished, this, &HuggingfaceModelList::onReplyFinished);

    fetchModels();
}

int HuggingfaceModelList::count() const {
    return m_models.count();
}

int HuggingfaceModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_models.count();
}

QVariant HuggingfaceModelList::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_models.count())
        return QVariant();

    HuggingfaceModel* model = m_models[index.row()];

    switch (role) {
    case IdRole:
    case IdModelRole:
        return model->id();
    case NameRole:
        return model->name();
    case IconRole:
        return model->icon();
    case LikesRole:
        return model->likes();
    case DownloadsRole:
        return model->downloads();
    case PiplineTagRole:
        return model->pipelineTag();
    case LibraryNameRole:
        return model->libraryName();
    case TagsRole:
        return model->tags();
    case CreatedAtRole:
        return model->createdAt();
    case ModelObjectRole:
        return QVariant::fromValue(model);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> HuggingfaceModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[IdModelRole] = "idModel";
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    roles[LikesRole] = "likes";
    roles[DownloadsRole] = "downloads";
    roles[PiplineTagRole] = "piplineTag";
    roles[LibraryNameRole] = "libraryName";
    roles[TagsRole] = "tags";
    roles[CreatedAtRole] = "createdAt";
    roles[ModelObjectRole] = "modelObject";
    return roles;
}

void HuggingfaceModelList::fetchModels() {

    QUrl url("https://huggingface.co/api/models");
    QNetworkRequest request(url);
    m_manager->get(request);
}

void HuggingfaceModelList::loadMore(int count) {
    if (remainingModels.isEmpty()) return;

    QList<HuggingfaceModel*> toAdd = remainingModels.mid(0, count);
    remainingModels = remainingModels.mid(count);

    beginInsertRows(QModelIndex(), m_models.count(), m_models.count() + toAdd.count() - 1);
    for (auto *m : toAdd) {
        m->setParent(this);
        m_models.append(m);
    }
    endInsertRows();
    emit countChanged();
}

void HuggingfaceModelList::openModel(const QString& id, const QString& name, const QString& icon){
    if (m_hugginfaceInfo) {
        delete m_hugginfaceInfo;
        m_hugginfaceInfo = nullptr;
    }

    m_hugginfaceInfo = new HuggingfaceModelInfo(id, name, icon, this);
    m_hugginfaceInfo->fetchModelInfo();

    emit hugginfaceInfoChanged();

    qDebug() << "Opened HuggingFace model info with id:" << id;
}

void HuggingfaceModelList::closeModel(QString id){
    if (m_hugginfaceInfo && m_hugginfaceInfo->id() == id) {
        delete m_hugginfaceInfo;
        m_hugginfaceInfo = nullptr;

        emit hugginfaceInfoChanged();

        qDebug() << "Closed HuggingFace model info with id:" << id;
    }
}

void HuggingfaceModelList::addModel(const QString &idModel, const QString &fileName, const QString& type,
                                const QString &companyIcon)
{
    // 0. Validate the file extension (only accept .gguf files)
    if (!fileName.endsWith(".gguf", Qt::CaseInsensitive)) {
        qWarning() << "Invalid file type, only .gguf files are allowed:" << fileName;
        return;
    }

    // 1. Extract company name from the icon file
    QString companyName = companyIcon;
    if (companyName.endsWith(".svg", Qt::CaseInsensitive)) {
        companyName.chop(4); // remove ".svg"
    }

    // 2. Build the direct download URL
    QString url = QString("https://huggingface.co/%1/resolve/main/%2")
                      .arg(idModel, fileName);

    // 3. Use the file name as the model name
    QString name = fileName;

    // 4. Emit the signal with the collected information
    emit requestAddModel(name, url, type, companyName, companyIcon);
}

void HuggingfaceModelList::onReplyFinished(QNetworkReply *reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Network error:" << reply->errorString();
        reply->deleteLater();

        QString filePath = cacheFilePath();
        if(QFile::exists(filePath)){
            QFile file(filePath);
            if (file.open(QIODevice::ReadOnly)) {
                QByteArray rawData = file.readAll();
                file.close();
                processJson(rawData);
            }
        }
        return;
    }

    const QByteArray rawData = reply->readAll();
    reply->deleteLater();

    // Save to cache
    QFile file(cacheFilePath());
    if (file.open(QIODevice::WriteOnly)) {
        file.write(rawData);
        file.close();
    }

    // Process models
    processJson(rawData);
}

void HuggingfaceModelList::processJson(const QByteArray &rawData) {
    QtConcurrent::run([this, rawData]() {
        const QJsonDocument doc = QJsonDocument::fromJson(rawData);
        if (!doc.isArray()) {
            qWarning() << "Invalid JSON format";
            return;
        }

        QList<HuggingfaceModel*> allModels;
        QJsonArray filteredArray;

        const QJsonArray arr = doc.array();
        for (const QJsonValue &val : arr) {
            if (!val.isObject()) continue;
            const QJsonObject obj = val.toObject();

            QStringList tags;
            bool hasGguf = false;
            if (obj.contains("tags") && obj["tags"].isArray()) {
                for (const QJsonValue &tagVal : obj["tags"].toArray()) {
                    QString tag = tagVal.toString();
                    tags << tag;
                    if (tag.compare("gguf", Qt::CaseInsensitive) == 0) {
                        hasGguf = true;
                    }
                }
            }

            if (!hasGguf) continue;

            HuggingfaceModel *model = new HuggingfaceModel(
                obj["id"].toString(),
                obj["likes"].toInt(),
                obj["downloads"].toInt(),
                obj["pipeline_tag"].toString(),
                obj["library_name"].toString(),
                tags,
                obj["createdAt"].toString(),
                nullptr
                );

            allModels.append(model);
            filteredArray.append(obj);
        }

        QFile file(cacheFilePath());
        if (file.open(QIODevice::WriteOnly)) {
            QJsonDocument filteredDoc(filteredArray);
            file.write(filteredDoc.toJson(QJsonDocument::Indented));
            file.close();
        }

        QList<HuggingfaceModel*> initialModels = allModels.mid(0, 15);
        remainingModels = allModels.mid(15);

        QMetaObject::invokeMethod(this, [this, initialModels]() {
            beginResetModel();
            qDeleteAll(m_models);
            m_models = initialModels;
            for (auto *m : m_models)
                m->setParent(this);
            endResetModel();
            emit countChanged();
        }, Qt::QueuedConnection);
    });
}

QString HuggingfaceModelList::cacheFilePath() const {
    QString dirPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dirPath);
    return dirPath + "/huggingface_models.json";
}

HuggingfaceModelInfo* HuggingfaceModelList::hugginfaceInfo() {return m_hugginfaceInfo;}
