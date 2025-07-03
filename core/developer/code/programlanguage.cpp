#include "programlanguage.h"

ProgramLanguage::ProgramLanguage(const int id, const QString& name, QObject* parent)
    :m_id(id), m_name(name), m_codeGenerator(nullptr), QObject(parent){}

ProgramLanguage::~ProgramLanguage(){}

const int ProgramLanguage::id() const{return m_id;}

const QString &ProgramLanguage::name() const{return m_name;}

CodeGenerator *ProgramLanguage::getCodeGenerator() const{return m_codeGenerator;}
void ProgramLanguage::setCodeGenerator(CodeGenerator *newCodeGenerator) {
    if (m_codeGenerator == newCodeGenerator)
        return;

    if (m_codeGenerator && newCodeGenerator == nullptr) {
        m_codeGenerator->deleteLater();
    }

    m_codeGenerator = newCodeGenerator;
    emit codeGeneratorChanged();
}
