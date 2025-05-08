#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QPalette>
#include <QIcon>

#include "database.h"
#include "speechtotext.h"
#include "systemmonitor.h"

#include "./model/companylist.h"
#include "./model/companylistfilter.h"
#include "./model/BackendType.h"

#include "./model/offline/offlinemodellist.h"
#include "./model/online/onlinemodellist.h"

#include "./model/offline/offlinemodellistfilter.h"
#include "./model/online/onlinemodellistfilter.h"

#include "./conversation/conversationlist.h"
#include "./conversation/conversationlistfilter.h"

#include "../cmake/config.h.in"

#include "clipboard.h"

#include "./library/textprocessor/messagetextprocessor.h"

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

    int fontId = QFontDatabase::addApplicationFont(":/fonts/DMSans-Regular.ttf");
    if (fontId == -1) {
        qWarning() << "Failed to load font!";
    } else {
        QStringList loadedFonts = QFontDatabase::applicationFontFamilies(fontId);
        qDebug() << "Loaded font families:" << loadedFonts;
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("QmlEngine", &engine);

    QStringList fontFamilies = QFontDatabase::families();
    engine.rootContext()->setContextProperty("availableFonts", fontFamilies);

    bool isDarkTheme = app.palette().color(QPalette::Window).value() < 128;
    engine.rootContext()->setContextProperty("isDarkTheme", isDarkTheme);

    SpeechToText* speechToText = SpeechToText::instance(&engine);
    engine.rootContext()->setContextProperty("speechToText", speechToText);

    engine.addImportPath("../view/component_library/button");
    engine.addImportPath("../view/component_library/style");

    qmlRegisterType<ChatViewTextProcessor>("MyMessageTextProcessor", 1, 0, "ChatViewTextProcessor");


    Database* database = Database::instance(&engine);

    CompanyList* companyList =  CompanyList::instance(&engine);

    CompanyListFilter* offlineCompanyList = new CompanyListFilter(companyList, BackendType::OfflineModel, &engine);
    CompanyListFilter* onlineCompanyList = new CompanyListFilter(companyList, BackendType::OnlineModel, &engine);
    engine.rootContext()->setContextProperty("offlineCompanyList", offlineCompanyList);
    engine.rootContext()->setContextProperty("onlineCompanyList", onlineCompanyList);

    OfflineModelList* offlineModelList = OfflineModelList::instance(&engine);
    OnlineModelList* onlineModelList = OnlineModelList::instance(&engine);
    engine.rootContext()->setContextProperty("offlineModelList", offlineModelList);
    engine.rootContext()->setContextProperty("onlineModelList", onlineModelList);

    QObject::connect(companyList, &CompanyList::requestReadModel, database, &Database::readModel, Qt::QueuedConnection);
    QObject::connect(database, &Database::addOnlineModel, onlineModelList, &OnlineModelList::addModel, Qt::QueuedConnection);
    QObject::connect(database, &Database::addOfflineModel, offlineModelList, &OfflineModelList::addModel, Qt::QueuedConnection);

    QObject::connect(onlineModelList, &OnlineModelList::requestUpdateKeyModel, database, &Database::updateKeyModel, Qt::QueuedConnection);
    QObject::connect(onlineModelList, &OnlineModelList::requestUpdateIsLikeModel, database, &Database::updateIsLikeModel, Qt::QueuedConnection);
    QObject::connect(offlineModelList, &OfflineModelList::requestUpdateKeyModel, database, &Database::updateKeyModel, Qt::QueuedConnection);
    QObject::connect(offlineModelList, &OfflineModelList::requestUpdateIsLikeModel, database, &Database::updateIsLikeModel, Qt::QueuedConnection);
    QObject::connect(offlineModelList, &OfflineModelList::requestAddModel, database, &Database::addModel, Qt::QueuedConnection);
    QObject::connect(offlineModelList, &OfflineModelList::requestDeleteModel, database, &Database::deleteModel, Qt::QueuedConnection);
    companyList->readDB();

    OfflineModelListFilter* offlineModelListFilter = new OfflineModelListFilter(offlineModelList, &engine);
    OnlineModelListFilter* onlineModelListFilter = new OnlineModelListFilter(onlineModelList, &engine);
    engine.rootContext()->setContextProperty("offlineModelListFilter", offlineModelListFilter);
    engine.rootContext()->setContextProperty("onlineModelListFilter", onlineModelListFilter);

    OfflineModelListFilter* offlineModelListIsDownloadingFilter = new OfflineModelListFilter(offlineModelList, &engine);
    offlineModelListIsDownloadingFilter->setFilterType(OfflineModelListFilter::FilterType::IsDownloading);
    engine.rootContext()->setContextProperty("offlineModelListIsDownloadingFilter", offlineModelListIsDownloadingFilter);

    OfflineModelListFilter* offlineModelListFinishedDownloadFilter = new OfflineModelListFilter(offlineModelList, &engine);
    offlineModelListFinishedDownloadFilter->setFilterType(OfflineModelListFilter::FilterType::DownloadFinished);
    engine.rootContext()->setContextProperty("offlineModelListFinishedDownloadFilter", offlineModelListFinishedDownloadFilter);

    OfflineModelListFilter* offlineModelListRecommendedFilter = new OfflineModelListFilter(offlineModelList, &engine);
    offlineModelListRecommendedFilter->setFilterType(OfflineModelListFilter::FilterType::Recommended);
    engine.rootContext()->setContextProperty("offlineModelListRecommendedFilter", offlineModelListRecommendedFilter);

    OnlineModelListFilter* onlineModelInstallFilter = new OnlineModelListFilter(onlineModelList, &engine);
    onlineModelInstallFilter->setFilterType(OnlineModelListFilter::FilterType::InstallModel);
    engine.rootContext()->setContextProperty("onlineModelInstallFilter", onlineModelInstallFilter);

    OnlineModelListFilter* onlineModelListRecommendedFilter = new OnlineModelListFilter(onlineModelList, &engine);
    onlineModelListRecommendedFilter->setFilterType(OnlineModelListFilter::FilterType::Recommended);
    engine.rootContext()->setContextProperty("onlineModelListRecommendedFilter", onlineModelListRecommendedFilter);

    SystemMonitor* systemMonitor = SystemMonitor::instance(&engine);
    engine.rootContext()->setContextProperty("systemMonitor", systemMonitor);


    ConversationList* conversationList = ConversationList::instance(&engine);
    engine.rootContext()->setContextProperty("conversationList", conversationList);
    ConversationListFilter* conversationListFilter = new ConversationListFilter(conversationList, &engine);
    engine.rootContext()->setContextProperty("conversationListFilter", conversationListFilter);

    QObject::connect(conversationList, &ConversationList::requestReadConversation, database, &Database::readConversation, Qt::QueuedConnection);
    QObject::connect(database, &Database::addConversation, conversationList, &ConversationList::addConversation, Qt::QueuedConnection);

    QObject::connect(conversationList, &ConversationList::requestInsertConversation, database, &Database::insertConversation, Qt::QueuedConnection);
    QObject::connect(conversationList, &ConversationList::requestDeleteConversation, database, &Database::deleteConversation, Qt::QueuedConnection);
    QObject::connect(conversationList, &ConversationList::requestUpdateDateConversation, database, &Database::updateDateConversation, Qt::QueuedConnection);
    QObject::connect(conversationList, &ConversationList::requestUpdateTitleConversation, database, &Database::updateTitleConversation, Qt::QueuedConnection);
    QObject::connect(conversationList, &ConversationList::requestUpdateIsPinnedConversation, database, &Database::updateIsPinnedConversation, Qt::QueuedConnection);
    QObject::connect(conversationList, &ConversationList::requestUpdateModelSettingsConversation, database, &Database::updateModelSettingsConversation, Qt::QueuedConnection);
    QObject::connect(conversationList, &ConversationList::requestUpdateFilterList, conversationListFilter, &ConversationListFilter::updateFilterList, Qt::QueuedConnection);
    conversationList->readDB();

    QObject::connect(conversationList, &ConversationList::requestReadMessages, database, &Database::readMessages, Qt::QueuedConnection);
    QObject::connect(database, &Database::addMessage, conversationList, &ConversationList::addMessage, Qt::QueuedConnection);
    QObject::connect(conversationList, &ConversationList::requestInsertMessage, database, &Database::insertMessage, Qt::QueuedConnection);
    QObject::connect(conversationList, &ConversationList::requestUpdateLikeMessage, database, &Database::updateLikeMessage, Qt::QueuedConnection);
    QObject::connect(conversationList, &ConversationList::requestUpdateTextMessage, database, &Database::updateTextMessage, Qt::QueuedConnection);

    Clipboard clipboard;
    engine.rootContext()->setContextProperty("Clipboard", &clipboard);

    const QUrl url(u"qrc:/view/Main.qml"_qs);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
