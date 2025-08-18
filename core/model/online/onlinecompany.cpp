#include "onlinecompany.h"

OnlineCompany::OnlineCompany(const int id, const QString& name, const QString& icon,
              const BackendType backend, const QString& filePath, QObject* parent)
    : Company(id, name, icon, backend, filePath, parent){}

OnlineModelList *OnlineCompany::onlineModelList() const{return m_onlineModelList;}

OnlineCompany::~OnlineCompany(){}
