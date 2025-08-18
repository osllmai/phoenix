#ifndef COMPANY_H
#define COMPANY_H

#include <QObject>
#include <QQmlEngine>
#include "BackendType.h"

class Company: public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
    Q_PROPERTY(QString name READ name CONSTANT FINAL)
    Q_PROPERTY(QString icon READ icon CONSTANT FINAL)

public:
    explicit Company(QObject* parent = nullptr) : QObject(parent) {}

    explicit Company(const int id, const QString& name, const QString& icon,
                                const BackendType backend, const QString& filePath, QObject* parent);

    virtual ~Company();

    const int id() const;

    const QString &name() const;

    const QString &icon() const;

    const BackendType backend() const;

    const QString &filePath() const;

private:
    int m_id;
    QString m_name;
    QString m_icon;
    QString m_filePath;
    BackendType m_backend;
};

#endif // COMPANY_H
