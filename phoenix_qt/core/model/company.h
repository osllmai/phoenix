#ifndef COMPANY_H
#define COMPANY_H

#include <QObject>
#include <QtQml>
#include "BackendType.h"

class Company: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
    Q_PROPERTY(QString name READ name CONSTANT FINAL)
    Q_PROPERTY(QString icon READ icon CONSTANT FINAL)

public:
    explicit Company(const int id, const QString& name, const QString& icon,
                                const QString backend, QObject* parent);
    virtual ~Company();

    const int id() const;

    const QString &name() const;

    const QString &icon() const;

    const BackendType backend() const;

private:
    int m_id;
    QString m_name;
    QString m_icon;
    BackendType m_backend;
};

#endif // COMPANY_H
