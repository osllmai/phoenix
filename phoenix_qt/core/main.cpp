#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

#include "database.h"

#include "./model/companylist.h"
#include "./model/companylistfilter.h"
#include "./model/BackendType.h"

#include "./model/offline/offlinemodellist.h"
#include "./model/online/onlinemodellist.h"


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

    QObject::connect(companyList, &CompanyList::requestReadModel, database, &Database::readModel, Qt::QueuedConnection);

    qmlRegisterSingletonInstance("onlinemodellist", 1, 0, "OnlineModelList", OnlineModelList::instance(&engine));
    qmlRegisterSingletonInstance("offlinemodellist", 1, 0, "OfflineModelListData", OfflineModelList::instance(&engine));

    CompanyListFilter* offlineCompanyList = new CompanyListFilter(BackendType::OfflineModel, CompanyList::instance());
    CompanyListFilter* onlineCompanyList = new CompanyListFilter(BackendType::OnlineModel, CompanyList::instance());
    offlineCompanyList->setSourceModel(companyList);
    onlineCompanyList->setSourceModel(companyList);
    engine.rootContext()->setContextProperty("zeinab", offlineCompanyList);
    engine.rootContext()->setContextProperty("offlineFilterModel", onlineCompanyList);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("phoenix_15", "Main");

    return app.exec();
}
