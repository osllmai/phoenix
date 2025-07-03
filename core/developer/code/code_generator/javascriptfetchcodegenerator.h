#ifndef JAVASCRIPTFETCHCODEGENERATOR_H
#define JAVASCRIPTFETCHCODEGENERATOR_H

#include <QObject>
#include <QQmlEngine>
#include "../codegenerator.h"

class JavascriptFetchCodeGenerator : public CodeGenerator {
    Q_OBJECT
    QML_ELEMENT

public:
    using CodeGenerator::CodeGenerator;
    QString getModels() override;
    QString postChat() override;
};

#endif // JAVASCRIPTFETCHCODEGENERATOR_H
