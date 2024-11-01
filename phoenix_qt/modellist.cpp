#include "modellist.h"

#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

ModelList::ModelList(QObject *parent)
    : QAbstractListModel(parent),m_currentModelList(new CurrentModelList(this))
{
    readModelFromJSONFile();

    // Open the database
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");  // Replace with the actual path to your DB
    if (!db.open()) {
        qDebug() << "Error: Unable to open database" << db.lastError().text();
        return;
    }

    // Prepare and execute the SQL query
    QSqlQuery query(db);

    // Create table with id and name columns
    query.exec("CREATE TABLE IF NOT EXISTS model (id INTEGER, name TEXT, path TEXT)");

    // Prepare query to select both id and name
    QString cmd = "SELECT id, name, path FROM model";

    // Execute the query
    if (!query.exec(cmd)) {
        qDebug() << "Error: Unable to insert data -" << query.lastError().text();
    } else {
        qDebug() << "Data inserted successfully."<<query.size();
        while(query.next()){
            int id = query.value(0).toInt();
            QString name = query.value(1).toString();
            QString path = query.value(2).toString();

            addModel(id ,0 , 0,  name, "", "", "", path, "", "", "", "", "","./images/Phoenix.svg", 0,  false, true);

        }
    }

    // Close the database
    db.close();
}

//*------------------------------------------------------------------------------**************************-----------------------------------------------------------------------------*//
//*------------------------------------------------------------------------------* QAbstractItemModel interface *------------------------------------------------------------------------------*//
int ModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return models.size();
}

QVariant ModelList::data(const QModelIndex &index, int role = Qt::DisplayRole) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= models.count())
        return QVariant();

    //The index is valid
    Model* model = models[index.row()];

    switch (role) {
    case IdRole:
        return model->id();
    case FileSizeRole:
        return model->fileSize();
    case RamRamrequiredRole:
        return model->ramRamrequired();
    case ParametersRole:
        return model->parameters();
    case QuantRole:
        return model->quant();
    case TypeRole:
        return model->type();
    case PromptTemplateRole:
        return model->promptTemplate();
    case SystemPromptRole:
        return model->systemPrompt();
    case NameRole:
        return model->name();
    case InformationRole:
        return model->information();
    case FileNameRole:
        return model->fileName();
    case UrlRole:
        return model->url();
    case DirectoryPathRole:
        return model->directoryPath();
    case IconModelRole:
        return model->icon();
    case DownloadPercentRole:
        return model->downloadPercent();
    case IsDownloadingRole:
        return model->isDownloading();
    case DownloadFinishedRole:
        return model->downloadFinished();
    }

    return QVariant();
}

QHash<int, QByteArray> ModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[FileSizeRole] = "fileSize";
    roles[RamRamrequiredRole] = "ramRamrequired";
    roles[ParametersRole] = "parameters";
    roles[QuantRole] = "quant";
    roles[TypeRole] = "type";
    roles[PromptTemplateRole] = "promptTemplate";
    roles[SystemPromptRole] = "systemPrompt";
    roles[NameRole] = "name";
    roles[InformationRole] = "information";
    roles[FileNameRole] = "fileName";
    roles[UrlRole] = "url";
    roles[DirectoryPathRole] = "directoryPath";
    roles[IconModelRole] = "icon";
    roles[DownloadPercentRole] = "downloadPercent";
    roles[IsDownloadingRole] = "isDownloading";
    roles[DownloadFinishedRole] = "downloadFinished";
    return roles;
}

Qt::ItemFlags ModelList::flags(const QModelIndex &index) const {
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

bool ModelList::setData(const QModelIndex &index, const QVariant &value, int role) {
    Model* model = models[index.row()]; // The person to edit
    bool somethingChanged{false};

    switch (role) {
    case IdRole:
        if( model->id()!= value.toInt()){
            model->setId(value.toInt());
            somethingChanged = true;
        }
        break;
    case FileSizeRole:
        if( model->fileSize()!= value.toDouble()){
            model->setFileSize(value.toDouble());
            somethingChanged = true;
        }
        break;
    case RamRamrequiredRole:
        if( model->ramRamrequired()!= value.toInt()){
            model->setRamRamrequired(value.toInt());
            somethingChanged = true;
        }
        break;
    case ParametersRole:
        if( model->parameters()!= value.toString()){
            model->setParameters(value.toString());
            somethingChanged = true;
        }
        break;
    case QuantRole:
        if( model->quant()!= value.toString()){
            model->setQuant(value.toString());
            somethingChanged = true;
        }
        break;
    case TypeRole:
        if( model->type()!= value.toString()){
            model->setType(value.toString());
            somethingChanged = true;
        }
        break;
    case PromptTemplateRole:
        if( model->promptTemplate()!= value.toString()){
            model->setPromptTemplate(value.toString());
            somethingChanged = true;
        }
        break;
    case SystemPromptRole:
        if( model->systemPrompt()!= value.toString()){
            model->setSystemPrompt(value.toString());
            somethingChanged = true;
        }
        break;
    case NameRole:
        if( model->name()!= value.toString()){
            model->setName(value.toString());
            somethingChanged = true;
        }
        break;
    case InformationRole:
        if( model->information()!= value.toString()){
            model->setInformation(value.toString());
            somethingChanged = true;
        }
        break;
    case FileNameRole:
        if( model->fileName()!= value.toString()){
            model->setFileName(value.toString());
            somethingChanged = true;
        }
        break;
    case UrlRole:
        if( model->url()!= value.toString()){
            model->setUrl(value.toString());
            somethingChanged = true;
        }
        break;
    case DirectoryPathRole:
        if( model->directoryPath()!= value.toString()){
            model->setDirectoryPath(value.toString());
            somethingChanged = true;
        }
        break;
    case IconModelRole:
        if( model->icon()!= value.toString()){
            model->setIcon(value.toString());
            somethingChanged = true;
        }
        break;
    case DownloadPercentRole:
        if( model->downloadPercent()!= value.toDouble()){
            model->setDownloadPercent(value.toDouble());
            somethingChanged = true;
        }
        break;
    case IsDownloadingRole:
        if( model->isDownloading()!= value.toBool()){
            model->setIsDownloading(value.toBool());
            somethingChanged = true;
        }
        break;
    case DownloadFinishedRole:
        if( model->downloadFinished()!= value.toBool()){
            model->setDownloadFinished(value.toBool());
            somethingChanged = true;
        }
    }
    if(somethingChanged){
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}
//*---------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
CurrentModelList *ModelList::currentModelList() const{
    return m_currentModelList;
}
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Write Property  *----------------------------------------------------------------------------------------*//
void ModelList::setCurrentModelList(CurrentModelList *currentModelList){
    if(m_currentModelList == currentModelList)
        return;
    m_currentModelList = currentModelList;
    emit currentModelListChanged();
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//


void ModelList::addModel(const int &id, const double &fileSize ,const int &ramRamrequired, const QString &name, const QString &information, const QString &fileName,
                         const QString &url, const QString &directoryPath, const QString &parameters, const QString &quant, const QString &type, const QString &promptTemplate,
                         const QString &systemPrompt, const QString &icon, const double &downloadPercent, const bool &isDownloading, const bool &downloadFinished){
    const int index = models.size();
    if(id<index){
        Model *model = models[id];
        model->setDownloadFinished(true);
        model->setDirectoryPath(directoryPath);
        m_currentModelList->addModel(model);
        // emit currentModelListChanged();
    }else{
        Model *model = new Model(id, fileSize, ramRamrequired, name, information, fileName, url , directoryPath, parameters, quant,
                                                    type, promptTemplate, systemPrompt, icon, downloadPercent, isDownloading, downloadFinished, this);
        beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
        models.append(model);
        endInsertRows();
        if(downloadFinished == true)
            m_currentModelList->addModel(model);
    }
}

void ModelList::downloadRequest(const int index , const QString &directoryPath){

    Model *model = models[index];
    model->setDirectoryPath(directoryPath);
    model->setIsDownloading(true);

    QString modelPath = directoryPath;
    modelPath.remove("file:///");
    modelPath = modelPath + "/" + model->fileName();

    Download *download = new Download(index);
    connect(download, &Download::downloadProgress, this, &ModelList::handleDownloadProgress, Qt::QueuedConnection);
    connect(download, &Download::downloadFinished, this, &ModelList::handleDownloadFinished, Qt::QueuedConnection);
    download->downloadModel(model->url(), modelPath);
    downloads.append(download);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DirectoryPathRole, IsDownloadingRole});
}

void ModelList::addModel(const QString &directoryPath){
    const int id = models.size();

    QString modelPath = directoryPath;
    modelPath.remove("file:///");

    QFileInfo fileInfo(modelPath);
    QString name = fileInfo.fileName();

    // Open the database
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");  // Replace with the actual path to your DB
    if (!db.open()) {
        qDebug() << "Error: Unable to open database" << db.lastError().text();
        return;
    }

    // Prepare and execute the SQL query
    QSqlQuery query(db);

    // Create table with id and name columns
    query.exec("CREATE TABLE IF NOT EXISTS model (id INTEGER, name TEXT, path TEXT)");

    // Prepare query to insert both id and name
    query.prepare("INSERT INTO model (id, name, path) VALUES (?, ?, ?)");

    // Bind values
    query.addBindValue(id);
    query.addBindValue(name);
    query.addBindValue(modelPath);

    // Execute the query
    if (!query.exec()) {
        qDebug() << "Error: Unable to insert data -" << query.lastError().text();
    } else {
        qDebug() << "Data inserted successfully.";
    }

    // Close the database
    db.close();

    addModel(id ,0 , 0,  name, "", "", "", modelPath, "", "", "", "", "","./images/Phoenix.svg", 0,  false, true);
}

void ModelList::handleDownloadProgress(const int index, qint64 bytesReceived, qint64 bytesTotal){
    Model *model = models[index];
    qDebug()<<static_cast<double>(bytesReceived)/static_cast<double>(bytesTotal);
    model->setDownloadPercent(static_cast<double>(bytesReceived)/static_cast<double>(bytesTotal));
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadPercentRole});
}

void ModelList::handleDownloadFinished(const int index){
    Model *model = models[index];
    model->setIsDownloading(false);
    model->setDownloadFinished(true);

    // Open the database
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");  // Replace with the actual path to your DB
    if (!db.open()) {
        qDebug() << "Error: Unable to open database" << db.lastError().text();
        return;
    }

    // Prepare and execute the SQL query
    QSqlQuery query(db);

    // Create table with id and name columns
    query.exec("CREATE TABLE IF NOT EXISTS model (id INTEGER, name TEXT, path TEXT)");

    // Prepare query to insert both id and name
    query.prepare("INSERT INTO model (id, name, path) VALUES (?, ?, ?)");

    // Bind values
    query.addBindValue(model->id());
    query.addBindValue(model->name());
    query.addBindValue(model->directoryPath());

    // Execute the query
    if (!query.exec()) {
        qDebug() << "Error: Unable to insert data -" << query.lastError().text();
    } else {
        qDebug() << "Data inserted successfully.";
    }

    // Close the database
    db.close();

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {IsDownloadingRole, DownloadFinishedRole});
}

void ModelList::cancelRequest(const int index){
    Model *model = models[index];
    for(int indexSearch =0 ;indexSearch<downloads.size();indexSearch++)
        if(downloads[indexSearch]->index() == index)
            downloads[indexSearch]->cancelDownload();
    model->setIsDownloading(false);
    model->setDownloadFinished(false);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadFinishedRole, IsDownloadingRole});
}

void ModelList::deleteRequest(const int index){
    Model *model = models[index];
    for(int indexSearch =0 ;indexSearch<downloads.size();indexSearch++)
        if(downloads[indexSearch]->index() == index)
            downloads[indexSearch]->removeModel();


    // Open the database
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");  // Replace with the actual path to your DB
    if (!db.open()) {
        qDebug() << "Error: Unable to open database" << db.lastError().text();
        return;
    }

    // Prepare and execute the SQL query
    QSqlQuery query(db);

    // Create table with id and name columns
    query.exec("CREATE TABLE IF NOT EXISTS model (id INTEGER, name TEXT, path TEXT)");

    // Prepare query to insert both id and name
    query.prepare("DELETE FROM model where id = ?");

    // Bind values
    query.addBindValue(model->id());

    // Execute the query
    if (!query.exec()) {
        qDebug() << "Error: Unable to insert data -" << query.lastError().text();
    } else {
        qDebug() << "Data inserted successfully.";
    }

    // Close the database
    db.close();


    if(model->url() == ""){
        const int newIndex = models.indexOf(model);
        beginRemoveRows(QModelIndex(), newIndex, newIndex);
        models.removeAll(model);
        endRemoveRows();
        // chat->unloadAndDeleteLater();
    }else{
        QFile file(model->directoryPath());
        qDebug()<< model->directoryPath();
        if (file.exists()){
            qDebug()<<"remove ";
            file.remove();
        }
    }

    model->setIsDownloading(false);
    model->setDownloadFinished(false);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadFinishedRole, IsDownloadingRole});

}


void ModelList::readModelFromJSONFile(){
    QFile file("./models.json");
    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << file.errorString();
        return;
    }
    QByteArray jsonData = file.readAll();
    file.close();

    QJsonParseError err;
    QJsonDocument document = QJsonDocument::fromJson(jsonData, &err);
    if (err.error != QJsonParseError::NoError) {
        qWarning() << "ERROR: Couldn't parse: " << jsonData << err.errorString();
        return;
    }

    QJsonArray jsonArray = document.array();
    int id=0;
    for (const QJsonValue &value : jsonArray) {
        QJsonObject jsonObj = value.toObject();

        QString modelName = jsonObj["name"].toString();
        QString modelFilename = jsonObj["filename"].toString();
        double modelFilesize = jsonObj["filesize"].toString().toDouble();
        QString url = jsonObj["url"].toString();
        int ramRamrequired = jsonObj["ramrequired"].toString().toInt();
        QString parameters = jsonObj["parameters"].toString();
        QString quant = jsonObj["quant"].toString();
        QString type = jsonObj["type"].toString();
        QString description = jsonObj["description"].toString();
        QString promptTemplate = jsonObj["promptTemplate"].toString();
        QString systemPrompt = jsonObj["systemPrompt"].toString();
        QString icon = jsonObj["icon"].toString();

        addModel(id, modelFilesize, ramRamrequired, modelName,  description, modelFilename, url, "", parameters, quant, type, promptTemplate, systemPrompt, icon, 0, false, false);
        id++;
    }
}
