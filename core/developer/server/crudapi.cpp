#include "crudapi.h"

CrudAPI::CrudAPI(const QString &scheme, const QString &hostName, int port)
    :scheme(scheme), hostName(hostName), port(port)
{}

QString CrudAPI::getScheme() const{return scheme;}

QString CrudAPI::getHostName() const{return hostName;}

int CrudAPI::getPort() const{return port;}
