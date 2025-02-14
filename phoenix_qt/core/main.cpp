#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

#include "database.h"

#include "./model/companylist.h"
#include "./model/companylistfilter.h"
#include "./model/BackendType.h"

#include "./model/offline/offlinemodellist.h"
#include "./model/online/onlinemodellist.h"

#include "./model/offline/offlinemodellistfilter.h"
#include "./model/online/onlinemodellistfilter.h"

#include "config.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("nemati.ai");
    QCoreApplication::setOrganizationDomain("indox.io");
    QCoreApplication::setApplicationName("PHOENIX");
    QCoreApplication::setApplicationVersion(APP_VERSION);

#ifdef Q_OS_WINDOWS
    app.setWindowIcon(QIcon(":/media/image_company/Phoenix.ico"));
#else
    app.setWindowIcon(QIcon(":/media/image_company/Phoenix.png"));
#endif

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("QmlEngine", &engine);

    engine.addImportPath("../view/component_library/button");
    engine.addImportPath("../view/component_library/style");

    Database* database = Database::instance(&engine);

    CompanyList* companyList =  CompanyList::instance(&engine);

    CompanyListFilter* offlineCompanyList = new CompanyListFilter(BackendType::OfflineModel, companyList);
    CompanyListFilter* onlineCompanyList = new CompanyListFilter(BackendType::OnlineModel, companyList);
    offlineCompanyList->setSourceModel(companyList);
    onlineCompanyList->setSourceModel(companyList);
    engine.rootContext()->setContextProperty("offlineCompanyList", offlineCompanyList);
    engine.rootContext()->setContextProperty("onlineCompanyList", onlineCompanyList);

    OfflineModelList* offlineModelList = OfflineModelList::instance(&engine);
    OnlineModelList* onlineModelList = OnlineModelList::instance(&engine);

    OfflineModelListFilter* offlineModelListFilter = new OfflineModelListFilter(offlineModelList, &engine);
    OnlineModelListFilter* onlineModelListFilter = new OnlineModelListFilter(&engine);
    // offlineModelListFilter->setSourceModel(offlineModelList);
    // onlineModelListFilter->setSourceModel(onlineModelList);
    engine.rootContext()->setContextProperty("offlineModelListFilter", offlineModelListFilter);
    engine.rootContext()->setContextProperty("onlineModelListFilter", onlineModelListFilter);

    QObject::connect(companyList, &CompanyList::requestReadModel, database, &Database::readModel, Qt::QueuedConnection);
    QObject::connect(database, &Database::setOnlineModelList, onlineModelList, &OnlineModelList::setModelList, Qt::QueuedConnection);
    QObject::connect(database, &Database::setOfflineModelList, offlineModelList, &OfflineModelList::setModelList, Qt::QueuedConnection);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("phoenix_15", "Main");

    return app.exec();
}
