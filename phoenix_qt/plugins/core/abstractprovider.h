#pragma once

#include <QObject>

class AbstractProvider : public QObject
{
    Q_OBJECT

public:
    explicit AbstractProvider(QObject *parent = nullptr);

    virtual QString name() const = 0;
    virtual QString descript() const;

    virtual void prompt(const QString &text);

Q_SIGNALS:
    void tokenRecivied(const QString &token);
    void finished();
    void loadModelFinished(bool ok);
};
