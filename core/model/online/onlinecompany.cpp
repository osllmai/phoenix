#include "onlinecompany.h"

OnlineCompany::OnlineCompany(const int id, const QString& name, const QString& icon,
              const BackendType backend, const QString& filePath, QString key, QObject* parent)
    : Company(id, name, icon, backend, filePath, parent), m_key(key){}

OnlineModelList *OnlineCompany::onlineModelList() const{return m_onlineModelList;}

OnlineCompany::~OnlineCompany(){}

QString OnlineCompany::key() const{return m_key;}
void OnlineCompany::setKey(const QString &newKey){
    if (m_key == newKey)
        return;
    m_key = newKey;
    emit keyChanged();
}
