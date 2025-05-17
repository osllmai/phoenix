#include "programlanguage.h"

ProgramLanguage::ProgramLanguage(const int id, const QString& name, QObject* parent)
    :m_id(id), m_name(name), QObject(parent){}

ProgramLanguage::~ProgramLanguage(){}

const int ProgramLanguage::id() const{return m_id;}

const QString &ProgramLanguage::name() const{return m_name;}
