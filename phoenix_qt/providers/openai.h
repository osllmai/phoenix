#pragma once

#include "abstractprovider.h"

class QNetworkAccessManager;
class OpenAI : public AbstractProvider
{
    Q_OBJECT
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged FINAL)

public:
    OpenAI();

    void send(const QString &message) override;
    QString apiKey() const;
    void setApiKey(const QString &newApiKey);

private Q_SLOTS:
    void onReplyFinished() ;

Q_SIGNALS:
    void apiKeyChanged();

private:
    QString m_apiKey;
    QNetworkAccessManager* networkManager;

};
