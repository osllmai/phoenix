#ifndef PROGRAMLANGUAGE_H
#define PROGRAMLANGUAGE_H

#include <QObject>
#include <QQmlEngine>
#include "codegenerator.h"

class ProgramLanguage: public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
    Q_PROPERTY(QString name READ name CONSTANT FINAL)
    Q_PROPERTY(CodeGenerator *codeGenerator READ getCodeGenerator WRITE setCodeGenerator NOTIFY codeGeneratorChanged FINAL)

public:
    explicit ProgramLanguage(QObject* parent = nullptr) : QObject(parent) {}

    explicit ProgramLanguage(const int id, const QString& name, QObject* parent);
    virtual ~ProgramLanguage();

    const int id() const;

    const QString &name() const;

    CodeGenerator *getCodeGenerator() const;
    void setCodeGenerator(CodeGenerator *newCodeGenerator);

signals:
    void codeGeneratorChanged();

private:
    int m_id;
    QString m_name;
    CodeGenerator* m_codeGenerator;
};

#endif // PROGRAMLANGUAGE_H
