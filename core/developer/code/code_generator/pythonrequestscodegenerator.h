#ifndef PYTHONREQUESTSCODEGENERATOR_H
#define PYTHONREQUESTSCODEGENERATOR_H

#include <QObject>
#include <QQmlEngine>
#include "../codegenerator.h"

class PythonRequestsCodeGenerator : public CodeGenerator {
    Q_OBJECT
    QML_ELEMENT

public:
    using CodeGenerator::CodeGenerator;
    QString getModels() override;
    QString postChat() override;
};

#endif // PYTHONREQUESTSCODEGENERATOR_H
