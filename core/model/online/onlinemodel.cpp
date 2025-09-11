#include "onlinemodel.h"

OnlineModel::OnlineModel(const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                         const QString& type, const BackendType backend,
                         const QString& icon , const QString& information , const QString& promptTemplate ,
                         const QString& systemPrompt, QDateTime expireModelTime, const bool recommended, QObject* parent,

                         const double inputPricePer1KTokens, const double outputPricePer1KTokens,
                         const QString& contextWindows, const bool commercial, const bool pricey,
                         const QString& output, const QString& comments
                         )
                         :Model(id, modelName, name, key, addModelTime, type, backend, icon, information,
                                    promptTemplate, systemPrompt, expireModelTime, recommended, parent),

                                    m_inputPricePer1KTokens(inputPricePer1KTokens),
                                    m_outputPricePer1KTokens(outputPricePer1KTokens), m_contextWindows(contextWindows),
                                    m_commercial(commercial), m_pricey(pricey),
                                    m_output(output), m_comments(comments)
{}

OnlineModel::~OnlineModel(){}

const double OnlineModel::inputPricePer1KTokens() const{return m_inputPricePer1KTokens;}

const double OnlineModel::outputPricePer1KTokens() const{return m_outputPricePer1KTokens;}

const QString &OnlineModel::contextWindows() const{return m_contextWindows;}

const bool OnlineModel::commercial() const{return m_commercial;}

const bool OnlineModel::pricey() const{return m_pricey;}

const QString &OnlineModel::output() const{return m_output;}

const QString &OnlineModel::comments() const{return m_comments;}
