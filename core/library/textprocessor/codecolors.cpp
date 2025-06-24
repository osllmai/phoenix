#include "codecolors.h"

CodeColors::CodeColors(QObject* parent)
    : QObject{nullptr}
{}

CodeColors::~CodeColors(){}

CodeColors* CodeColors::m_instance = nullptr;

CodeColors* CodeColors::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new CodeColors(parent);
    }
    return m_instance;
}

QColor CodeColors::getDefaultColor() const{return defaultColor;}
void CodeColors::setDefaultColor(const QColor &newDefaultColor){
    if (defaultColor == newDefaultColor)
        return;
    defaultColor = newDefaultColor;
    emit defaultColorChanged();
}

QColor CodeColors::getKeywordColor() const{return keywordColor;}
void CodeColors::setKeywordColor(const QColor &newKeywordColor){
    if (keywordColor == newKeywordColor)
        return;
    keywordColor = newKeywordColor;
    emit keywordColorChanged();
}

QColor CodeColors::getFunctionColor() const{return functionColor;}
void CodeColors::setFunctionColor(const QColor &newFunctionColor){
    if (functionColor == newFunctionColor)
        return;
    functionColor = newFunctionColor;
    emit functionColorChanged();
}

QColor CodeColors::getFunctionCallColor() const{return functionCallColor;}
void CodeColors::setFunctionCallColor(const QColor &newFunctionCallColor){
    if (functionCallColor == newFunctionCallColor)
        return;
    functionCallColor = newFunctionCallColor;
    emit functionCallColorChanged();
}

QColor CodeColors::getCommentColor() const{return commentColor;}
void CodeColors::setCommentColor(const QColor &newCommentColor){
    if (commentColor == newCommentColor)
        return;
    commentColor = newCommentColor;
    emit commentColorChanged();
}

QColor CodeColors::getStringColor() const{return stringColor;}
void CodeColors::setStringColor(const QColor &newStringColor){
    if (stringColor == newStringColor)
        return;
    stringColor = newStringColor;
    emit stringColorChanged();
}

QColor CodeColors::getNumberColor() const{return numberColor;}
void CodeColors::setNumberColor(const QColor &newNumberColor){
    if (numberColor == newNumberColor)
        return;
    numberColor = newNumberColor;
    emit numberColorChanged();
}

QColor CodeColors::getHeaderColor() const{return headerColor;}
void CodeColors::setHeaderColor(const QColor &newHeaderColor){
    if (headerColor == newHeaderColor)
        return;
    headerColor = newHeaderColor;
    emit headerColorChanged();
}

QColor CodeColors::getBackgroundColor() const{return backgroundColor;}
void CodeColors::setBackgroundColor(const QColor &newBackgroundColor){
    if (backgroundColor == newBackgroundColor)
        return;
    backgroundColor = newBackgroundColor;
    emit backgroundColorChanged();
}

QColor CodeColors::getPreprocessorColor() const{return preprocessorColor;}
void CodeColors::setPreprocessorColor(const QColor &newPreprocessorColor){
    if (preprocessorColor == newPreprocessorColor)
        return;
    preprocessorColor = newPreprocessorColor;
    emit preprocessorColorChanged();
}

QColor CodeColors::getTypeColor() const{return typeColor;}
void CodeColors::setTypeColor(const QColor &newTypeColor){
    if (typeColor == newTypeColor)
        return;
    typeColor = newTypeColor;
    emit typeColorChanged();
}

QColor CodeColors::getArrowColor() const{return arrowColor;}
void CodeColors::setArrowColor(const QColor &newArrowColor){
    if (arrowColor == newArrowColor)
        return;
    arrowColor = newArrowColor;
    emit arrowColorChanged();
}

QColor CodeColors::getCommandColor() const{return commandColor;}
void CodeColors::setCommandColor(const QColor &newCommandColor){
    if (commandColor == newCommandColor)
        return;
    commandColor = newCommandColor;
    emit commandColorChanged();
}

QColor CodeColors::getVariableColor() const{return variableColor;}
void CodeColors::setVariableColor(const QColor &newVariableColor){
    if (variableColor == newVariableColor)
        return;
    variableColor = newVariableColor;
    emit variableColorChanged();
}

QColor CodeColors::getKeyColor() const{return keyColor;}
void CodeColors::setKeyColor(const QColor &newKeyColor){
    if (keyColor == newKeyColor)
        return;
    keyColor = newKeyColor;
    emit keyColorChanged();
}

QColor CodeColors::getValueColor() const{return valueColor;}
void CodeColors::setValueColor(const QColor &newValueColor){
    if (valueColor == newValueColor)
        return;
    valueColor = newValueColor;
    emit valueColorChanged();
}

QColor CodeColors::getParameterColor() const{return parameterColor;}
void CodeColors::setParameterColor(const QColor &newParameterColor){
    if (parameterColor == newParameterColor)
        return;
    parameterColor = newParameterColor;
    emit parameterColorChanged();
}

QColor CodeColors::getAttributeNameColor() const{return attributeNameColor;}
void CodeColors::setAttributeNameColor(const QColor &newAttributeNameColor){
    if (attributeNameColor == newAttributeNameColor)
        return;
    attributeNameColor = newAttributeNameColor;
    emit attributeNameColorChanged();
}

QColor CodeColors::getAttributeValueColor() const{return attributeValueColor;}
void CodeColors::setAttributeValueColor(const QColor &newAttributeValueColor){
    if (attributeValueColor == newAttributeValueColor)
        return;
    attributeValueColor = newAttributeValueColor;
    emit attributeValueColorChanged();
}

QColor CodeColors::getSpecialCharacterColor() const{return specialCharacterColor;}
void CodeColors::setSpecialCharacterColor(const QColor &newSpecialCharacterColor){
    if (specialCharacterColor == newSpecialCharacterColor)
        return;
    specialCharacterColor = newSpecialCharacterColor;
    emit specialCharacterColorChanged();
}

QColor CodeColors::getDoctypeColor() const{return doctypeColor;}
void CodeColors::setDoctypeColor(const QColor &newDoctypeColor){
    if (doctypeColor == newDoctypeColor)
        return;
    doctypeColor = newDoctypeColor;
    emit doctypeColorChanged();
}
