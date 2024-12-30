#pragma once

#include <abstractchatprovider.h>

class QNetworkReply;
class QNetworkAccessManager;
class NerdToken : public AbstractChatProvider
{
    Q_OBJECT
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged FINAL)
    Q_PROPERTY(QString modelName READ modelName WRITE setModelName NOTIFY modelNameChanged FINAL)

    void prompt(const QString &input) override;

public:
    explicit NerdToken(QObject *parent = nullptr);
    QString apiKey() const;
    void setApiKey(const QString &newApiKey);

    QString modelName() const;
    void setModelName(const QString &newModelName);

Q_SIGNALS:
    void apiKeyChanged();

    void modelNameChanged();

private:
    QString m_apiKey;
    QNetworkAccessManager *networkManager;
    QNetworkReply *_reply{};
    QString m_modelName;
    std::atomic<bool> _stopFlag;
};
