#include "workflowtemplatesstorage.h"

#include "abstractrelation.h"
#include "block.h"
#include "workfloweditorarea.h"

#include <QDir>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>

namespace Exporter {
QJsonObject serialize(Block *block)
{
    QJsonObject object;

    object.insert("class", block->metaObject()->className());
    object.insert("uuid", block->uuid().toString(QUuid::WithoutBraces));
    object.insert("x", block->x());
    object.insert("y", block->y());
    object.insert("width", block->width());
    object.insert("height", block->height());

    return object;
}

QJsonObject serialize(AbstractRelation *relation)
{
    QJsonObject object;

    Block *startBlock{nullptr};
    Block *endBlock{nullptr};

    if (relation->startHandle())
        startBlock = qobject_cast<Block *>(relation->startHandle()->parentItem());
    if (relation->endHandle())
        endBlock = qobject_cast<Block *>(relation->endHandle()->parentItem());

    if (startBlock)
        object.insert("from", startBlock->uuid().toString(QUuid::WithoutBraces));
    if (endBlock)
        object.insert("to", endBlock->uuid().toString(QUuid::WithoutBraces));
    return object;
}

} // namespace Exporter
WorkflowTemplatesStorage::WorkflowTemplatesStorage(QObject *parent)
    : QObject{parent}
{
    _storagePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
                   + "/templates/workflows";

    qDebug() << "Templates path=" << _storagePath;

    QDir d{_storagePath};

    if (!d.exists())
        d.mkpath(_storagePath);

    loadTemplates();
}

QVariantList WorkflowTemplatesStorage::templates() const
{
    return m_templates;
}

QString WorkflowTemplatesStorage::save(WorkFlowEditorArea *area, const QString &fileName)
{
    QFile f{_storagePath + "/" + fileName};
    if (!f.open(QIODevice::WriteOnly))
        return "";

    auto blocks = area->blocks();
    auto relations = area->relations();

    QJsonObject o;
    QJsonArray blocksArray;
    QJsonArray relationsArray;

    for (auto &b:blocks)
        blocksArray.append(Exporter::serialize(b));
    for (auto &r: relations)
        relationsArray.append(Exporter::serialize(r));

    o.insert("blocks", blocksArray);
    o.insert("relations", relationsArray);

    auto content =  QJsonDocument(o).toJson();
    f.write(content);
    f.close();
    return "";
}

void WorkflowTemplatesStorage::loadTemplates()
{
    QDir d{_storagePath};
    auto files = d.entryInfoList({"*.json"}, QDir::Files);
    for (QFileInfo fi : files) {
        QVariantMap map;

        auto imagePath = _storagePath + "/" + fi.baseName();
        if (QFile::exists(imagePath))
            map.insert("image", imagePath);

        map.insert("path", fi.absolutePath());
        map.insert("file", fi.fileName());
        map.insert("title", fi.baseName());

        m_templates << map;
    }
}
