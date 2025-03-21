#ifndef ONLINEPROVIDER_H
#define ONLINEPROVIDER_H

#include "provider.h"
#include <QThread>
#include <QDebug>

class OnlineProvider : public  Provider
{
    Q_OBJECT
public:
    OnlineProvider(QObject* parent = nullptr);
    virtual ~OnlineProvider();

public slots:
    void prompt(const QString &input) override;
    void stop() override;
    void loadModel(const QString &model, const QString &key) override;
    void unLoadModel() override;

private:
    QThread chatLLMThread;
    std::atomic<bool> _stopFlag;

    QString m_model;
    QString m_key;

    bool handleResponse(int32_t token, const std::string &response);
};

#endif // ONLINEPROVIDER_H
