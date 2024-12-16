#pragma once

#include <QObject>
#include <QQmlEngine>

class WorkFlowRunner;
class WorkFlowStepField;
class WorkFlowStep : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(QQmlListProperty<WorkFlowStepField> fields READ fields NOTIFY fieldsChanged FINAL)
    Q_PROPERTY(bool isReady READ isReady  NOTIFY isReadyChanged FINAL)

public:
    WorkFlowStep(WorkFlowRunner *parent, const QString &name);

    virtual void init();
    virtual void run();

    WorkFlowRunner *parentRunner() const;

    QQmlListProperty<WorkFlowStepField> fields();
    QList<WorkFlowStepField *> fieldsList() const;

    Q_INVOKABLE void setFieldValue(const QString &name, const QVariant &value);

    bool isReady() const;

    QString name() const;
    void setName(const QString &newName);

Q_SIGNALS:
    void finished();

    void fieldsChanged();

    void isReadyChanged();

    void nameChanged();

protected:
    WorkFlowStepField *createInputField(const QString &name);
    WorkFlowStepField *createOutputField(const QString &name);
    virtual bool checkReady() const;

private:
    WorkFlowRunner *_parentRunner;
    QList<WorkFlowStepField *> _fields;
    QString m_name;

    static void appendField(QQmlListProperty<WorkFlowStepField> *list, WorkFlowStepField *field);
    static qsizetype fieldCount(QQmlListProperty<WorkFlowStepField> *list);
    static WorkFlowStepField *fieldAt(QQmlListProperty<WorkFlowStepField> *list, qsizetype index);
    static void clearFields(QQmlListProperty<WorkFlowStepField> *list);
};
