#pragma once

#include <QObject>

class AbstractProvider : public QObject
{
    Q_OBJECT

public:
    explicit AbstractProvider(QObject *parent = nullptr);

    virtual QString name() const = 0;
    virtual QString descript() const;

Q_SIGNALS:
    void tokenRecivied(const QString &token);
    void finished();
};
