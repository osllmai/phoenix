#ifndef UTILS_H
#define UTILS_H

#include <QtCore/QUrl>
#include <QtCore/QCommandLineOption>
#include <QtCore/QCommandLineParser>
#include <QStyleHints>
#include <QScreen>
#include <QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtWebView/QtWebView>

using namespace Qt::StringLiterals;
class Utils : public QObject
{
    Q_OBJECT
public:
    using QObject::QObject;

    Q_INVOKABLE static QUrl fromUserInput(const QString &userInput);
};

#endif // UTILS_H
