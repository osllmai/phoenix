#include "offlinemodellist.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

OfflineModelList* OfflineModelList::m_instance = nullptr;

OfflineModelList* OfflineModelList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new OfflineModelList(parent);
    }
    return m_instance;
}

OfflineModelList::OfflineModelList(QObject* parent) {}

int OfflineModelList::count() const{return models.count();}

int OfflineModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return models.count();
}

QVariant OfflineModelList::data(const QModelIndex &index, int role = Qt::DisplayRole) const{
    if (!index.isValid() || index.row() < 0 || index.row() >= models.count())
        return QVariant();

    OfflineModel* model = models[index.row()];

    switch (role) {
    case IdRole:
        return model->id();
    case NameRole:
        return model->name();
    case InformationRole:
        return model->information();
    case IconModelRole:
        return model->icon();
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
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> OfflineModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[InformationRole] = "information";
    roles[IconModelRole] = "icon";
    roles[IsLikeRole] = "isLike";
    roles[AddModelTimeRole] = "addModelTime";
    roles[FileSizeRole] = "fileSize";
    roles[RamRamrequiredRole] = "ramRamrequired";
    roles[ParametersRole] = "parameters";
    roles[QuantRole] = "quant";
    roles[DownloadFinishedRole] = "downloadFinished";
    roles[IsDownloadingRole] = "isDownloading";
    return roles;
}

bool OfflineModelList::setData(const QModelIndex &index, const QVariant &value, int role) {
    OfflineModel* model = models[index.row()]; // The person to edit
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

OfflineModel* OfflineModelList::at(int index) const{
    if (index < 0 || index >= models.count())
        return nullptr;
    return models.at(index);
}

void OfflineModelList::loadFromJsonAsync(const QList<Company*> companys) {
    connect(&futureWatcher, &QFutureWatcher<QList<OfflineModel*>>::finished, this, [this]() {
        beginResetModel();
        models = futureWatcher.result();
        endResetModel();
        for(OfflineModel* model: models){
            qInfo()<<model->name();
        }
        emit countChanged();
    });

    QFuture<QList<OfflineModel*>> future = QtConcurrent::run(parseJson, companys);
    futureWatcher.setFuture(future);
}


QList<OfflineModel*> OfflineModelList::parseJson(const QList<Company*> companys) {

    QList<OfflineModel*> tempModel;
    int i=0;

    for (Company* company : companys){
        if(company->backend() != BackendType::OfflineModel)
            continue;

        QFile file("./bin/" + company->filePath());
        if (!file.open(QIODevice::ReadOnly)) {
            qWarning() << "Cannot open JSON file!";
            continue;
        }

        QByteArray jsonData = file.readAll();
        file.close();

        QJsonParseError err;
        QJsonDocument document = QJsonDocument::fromJson(jsonData, &err);
        if (err.error != QJsonParseError::NoError) {
            qWarning() << "ERROR: Couldn't parse: " << jsonData << err.errorString();
            continue;
        }

        QJsonArray jsonArray = document.array();
        for (const QJsonValue &value : jsonArray) {
            if (!value.isObject()) continue;

            QJsonObject obj = value.toObject();
            if(obj["type"].toString() != company->name()) continue;

            OfflineModel *model = new OfflineModel(obj["filesize"].toDouble(), obj["ramrequired"].toInt(), obj["filename"].toString(),
                                                   obj["url"].toString(), obj["parameters"].toString(), obj["quant"].toString(),0.0, false, false,

                                                   i++, obj["name"].toString(), "", QDateTime::currentDateTime(), true, company, BackendType::OfflineModel,
                                                   company->icon(), obj["description"].toString(), obj["promptTemplate"].toString(),
                                                   obj["systemPrompt"].toString(), QDateTime::currentDateTime(), nullptr);

            tempModel.append(model);
        }
    }

    return tempModel;
}
