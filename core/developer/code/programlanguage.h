#ifndef PROGRAMLANGUAGE_H
#define PROGRAMLANGUAGE_H

#include <QObject>
#include <QQmlEngine>

class ProgramLanguage: public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
    Q_PROPERTY(QString name READ name CONSTANT FINAL)

public:
    explicit ProgramLanguage(QObject* parent = nullptr) : QObject(parent) {}

    explicit ProgramLanguage(const int id, const QString& name, QObject* parent);
    virtual ~ProgramLanguage();

    const int id() const;

    const QString &name() const;

private:
    int m_id;
    QString m_name;
};

#endif // PROGRAMLANGUAGE_H
