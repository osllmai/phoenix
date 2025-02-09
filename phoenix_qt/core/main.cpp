#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

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

    qmlRegisterSingletonInstance("companylist", 1, 0, "CompanyList", CompanyList::instance(&engine));
    qmlRegisterSingletonInstance("onlinemodellist", 1, 0, "OnlineModelList", OnlineModelList::instance(&engine));
    qmlRegisterSingletonInstance("offlinemodellist", 1, 0, "OfflineModelList", OfflineModelList::instance(&engine));

    CompanyListFilter* offlineCompanyList = new CompanyListFilter(BackendType::OfflineModel, CompanyList::instance());
    CompanyListFilter* onlineCompanyList = new CompanyListFilter(BackendType::OnlineModel, CompanyList::instance());
    offlineCompanyList->setSourceModel(CompanyList::instance());
    onlineCompanyList->setSourceModel(CompanyList::instance());
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
