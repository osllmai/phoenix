#ifndef CHATAPI_H
#define CHATAPI_H

#include <QtGui/QColor>
#include <QtCore/QDateTime>
#include <QtCore/QJsonArray>
#include <QtCore/QJsonObject>
#include <QtCore/QJsonParseError>
#include <QtCore/QString>
#include <QtCore/qtypes.h>
#include <QList>

#include <QSharedPointer>
#include <QHttpServerResponder>

#include <algorithm>
#include <optional>
#include "../crudapi.h"

#include "onlinemodel.h"
#include "offlinemodel.h"
#include "onlinemodellist.h"
#include "offlinemodellist.h"
#include "offlinemodellistfilter.h"
#include "onlinemodellistfilter.h"

#include "model.h"
#include "modelsettings.h"

#include "provider.h"
#include "offlineprovider.h"
#include "onlineprovider.h"
#include "codedeveloperlist.h"

#include <QLoggingCategory>
#include "logcategories.h"

class ChatAPI : public CrudAPI
{
    Q_OBJECT
    QML_SINGLETON

    Q_PROPERTY(Model *model READ model NOTIFY modelChanged FINAL)
    Q_PROPERTY(ModelSettings *modelSettings READ modelSettings NOTIFY modelSettingsChanged FINAL)
    Q_PROPERTY(bool isLoadModel READ isLoadModel WRITE setIsLoadModel NOTIFY isLoadModelChanged FINAL)
    Q_PROPERTY(bool loadModelInProgress READ loadModelInProgress WRITE setLoadModelInProgress NOTIFY loadModelInProgressChanged FINAL)
    Q_PROPERTY(bool responseInProgress READ responseInProgress WRITE setResponseInProgress NOTIFY responseInProgressChanged FINAL)

    Q_PROPERTY(int modelId READ modelId NOTIFY modelIdChanged FINAL)

public:

    ChatAPI(const QString &scheme, const QString &hostName, int port);

    QHttpServerResponse getFullList() const override;

    QHttpServerResponse getItem(qint64 itemId) const override;

    void postItem(const QHttpServerRequest &request, QSharedPointer<QHttpServerResponder> responder) override ;

    QHttpServerResponse updateItem(qint64 itemId, const QHttpServerRequest &request) override;

    QHttpServerResponse updateItemFields(qint64 itemId, const QHttpServerRequest &request) override;

    QHttpServerResponse deleteItem(qint64 itemId) override;

    Provider *provider() const;
    void setProvider(Provider *newProvider);


    int modelId() const;
    void setModelId(int newModelId);

    Model *model() const;
    void setModel(Model *newModel);

    ModelSettings *modelSettings() const;

    bool isLoadModel() const;
    void setIsLoadModel(bool newIsLoadModel);

    bool loadModelInProgress() const;
    void setLoadModelInProgress(bool newLoadModelInProgress);

    bool responseInProgress() const;
    void setResponseInProgress(bool newResponseInProgress);

public slots:
    void loadModelResult(const bool result, const QString &warning);
    void tokenResponse(const QString &token);
    void finishedResponse(const QString &warning);
    void updateModelSettingsDeveloper();

signals:
    void providerChanged();
    void modelIdChanged();
    void modelChanged();
    void modelSettingsChanged();
    void isLoadModelChanged();
    void loadModelInProgressChanged();
    void responseInProgressChanged();
    void requestUpdateModelSettingsDeveloper(const int id, const bool &stream,
                                             const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                             const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                             const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                             const int &contextLength, const int &numberOfGPULayers);
    void requestLoadModel(const QString &model, const QString &key);
    void requestUnLoadModel();
    void requestStop();


private:
    void prompt(const std::optional<QJsonObject> json);
    void loadModel(const int id);
    void unloadModel();

    Provider *m_provider;
    Model *m_model;
    ModelSettings *m_modelSettings;

    bool m_isLoadModel;
    bool m_loadModelInProgress;
    bool m_responseInProgress;

    int m_modelId;

    QSharedPointer<QHttpServerResponder> m_responder;

};

#endif // CHATAPI_H
