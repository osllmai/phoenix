#ifndef CURLCODEGENERATOR_H
#define CURLCODEGENERATOR_H

#include <QObject>
#include <QQmlEngine>
#include "../codegenerator.h"

class CurlCodeGenerator : public CodeGenerator {
    Q_OBJECT
    QML_ELEMENT

public:
    using CodeGenerator::CodeGenerator;
    QString getModels() override;
    QString postChat() override;
};

#endif // CURLCODEGENERATOR_H
