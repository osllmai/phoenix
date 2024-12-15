#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QVariantList>

class WorkFlowEditorArea;
class WorkflowTemplatesStorage : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariantList templates READ templates NOTIFY templatesChanged FINAL)

public:
    WorkflowTemplatesStorage(QObject * parent = nullptr);
    QVariantList templates() const;

    Q_INVOKABLE QString save(WorkFlowEditorArea *area, const QString &fileName);

Q_SIGNALS:
    void templatesChanged();

private:
    void loadTemplates();
    QVariantList m_templates;
    QString _storagePath;
};
