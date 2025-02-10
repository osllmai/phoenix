#include "onlinemodel.h"

OnlineModel::OnlineModel(const int id, const QString& name, const QString& key, QDateTime addModelTime,
                         const bool isLike, Company* company, const BackendType backend,
                         const QString& icon , const QString& information , const QString& promptTemplate ,
                         const QString& systemPrompt, QDateTime expireModelTime, QObject* parent)
                         :Model(id, name, key, addModelTime, isLike, company, backend, icon, information,
                                    promptTemplate, systemPrompt, expireModelTime, parent){}

OnlineModel::~OnlineModel(){}

const double OnlineModel::inputPricePer1KTokens() const{return m_inputPricePer1KTokens;}

const QString &OnlineModel::type() const{return m_type;}

const double OnlineModel::outputPricePer1KTokens() const{return m_outputPricePer1KTokens;}

const QString &OnlineModel::contextWindows() const{return m_contextWindows;}

const bool OnlineModel::recommended() const{return m_recommended;}

const bool OnlineModel::commercial() const{return m_commercial;}

const bool OnlineModel::pricey() const{return m_pricey;}

const QString &OnlineModel::output() const{return m_output;}

const QString &OnlineModel::comments() const{return m_comments;}

const bool OnlineModel::installModel() const{ return m_installModel;}
void OnlineModel::setInstallModel(const bool newInstallModel){
    if (m_installModel == newInstallModel)
        return;
    m_installModel = newInstallModel;
    emit installModelChanged();
}

