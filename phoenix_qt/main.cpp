#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Osllm.ai");
    QCoreApplication::setOrganizationDomain("phoenix.io");
    QCoreApplication::setApplicationName("PHOENIX");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/Phoenix/Main.qml"_qs);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
