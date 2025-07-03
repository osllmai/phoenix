#ifndef NODEJSAXIOSCODEGENERATOR_H
#define NODEJSAXIOSCODEGENERATOR_H

#include <QObject>
#include <QQmlEngine>
#include "../codegenerator.h"

class NodeJsAxiosCodeGenerator : public CodeGenerator {
    Q_OBJECT
    QML_ELEMENT

public:
    using CodeGenerator::CodeGenerator;
    QString getModels() override;
    QString postChat() override;
};

#endif // NODEJSAXIOSCODEGENERATOR_H
