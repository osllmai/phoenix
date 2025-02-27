#ifndef OFFLINEPROVIDER_H
#define OFFLINEPROVIDER_H

#include "provider.h"
#include <QThread>
#include <QDebug>

class OfflineProvider : public  Provider
{
    Q_OBJECT
public:
    OfflineProvider(Provider *parent);
    virtual ~OfflineProvider();

public slots:
    void prompt(const QString &input);
    void stop() override;
    void loadModel(const QString &modelPath) override;
    void unloadModel() override;

signals:
    void loadModelResult(const bool result, const QString warning);
    void tokenResponse(const QString &token);
    void finishedResponnse(const QString warning);

private:
    QThread chatLLMThread;
    std::atomic<bool> _stopFlag;

    bool handleResponse(int32_t token, const std::string &response);
};

#endif // OFFLINEPROVIDER_H
