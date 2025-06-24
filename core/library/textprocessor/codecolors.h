#ifndef CODECOLORS_H
#define CODECOLORS_H

#include <QColor>
#include <QObject>
#include <QQmlEngine>
#include <QQuickTextDocument> // IWYU pragma: keep
#include <QRectF>
#include <QSizeF>
#include <QString>
#include <QVector>

class CodeColors : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(QColor defaultColor READ getDefaultColor WRITE setDefaultColor NOTIFY defaultColorChanged FINAL)
    Q_PROPERTY(QColor keywordColor READ getKeywordColor WRITE setKeywordColor NOTIFY keywordColorChanged FINAL)
    Q_PROPERTY(QColor functionColor READ getFunctionColor WRITE setFunctionColor NOTIFY functionColorChanged FINAL)
    Q_PROPERTY(QColor functionCallColor READ getFunctionCallColor WRITE setFunctionCallColor NOTIFY functionCallColorChanged FINAL)
    Q_PROPERTY(QColor commentColor READ getCommentColor WRITE setCommentColor NOTIFY commentColorChanged FINAL)
    Q_PROPERTY(QColor stringColor READ getStringColor WRITE setStringColor NOTIFY stringColorChanged FINAL)
    Q_PROPERTY(QColor numberColor READ getNumberColor WRITE setNumberColor NOTIFY numberColorChanged FINAL)
    Q_PROPERTY(QColor headerColor READ getHeaderColor WRITE setHeaderColor NOTIFY headerColorChanged FINAL)
    Q_PROPERTY(QColor backgroundColor READ getBackgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged FINAL)
    Q_PROPERTY(QColor preprocessorColor READ getPreprocessorColor WRITE setPreprocessorColor NOTIFY preprocessorColorChanged FINAL)
    Q_PROPERTY(QColor typeColor READ getTypeColor WRITE setTypeColor NOTIFY typeColorChanged FINAL)
    Q_PROPERTY(QColor arrowColor READ getArrowColor WRITE setArrowColor NOTIFY arrowColorChanged FINAL)
    Q_PROPERTY(QColor commandColor READ getCommandColor WRITE setCommandColor NOTIFY commandColorChanged FINAL)
    Q_PROPERTY(QColor variableColor READ getVariableColor WRITE setVariableColor NOTIFY variableColorChanged FINAL)
    Q_PROPERTY(QColor keyColor READ getKeyColor WRITE setKeyColor NOTIFY keyColorChanged FINAL)
    Q_PROPERTY(QColor valueColor READ getValueColor WRITE setValueColor NOTIFY valueColorChanged FINAL)
    Q_PROPERTY(QColor parameterColor READ getParameterColor WRITE setParameterColor NOTIFY parameterColorChanged FINAL)
    Q_PROPERTY(QColor attributeNameColor READ getAttributeNameColor WRITE setAttributeNameColor NOTIFY attributeNameColorChanged FINAL)
    Q_PROPERTY(QColor attributeValueColor READ getAttributeValueColor WRITE setAttributeValueColor NOTIFY attributeValueColorChanged FINAL)
    Q_PROPERTY(QColor specialCharacterColor READ getSpecialCharacterColor WRITE setSpecialCharacterColor NOTIFY specialCharacterColorChanged FINAL)
    Q_PROPERTY(QColor doctypeColor READ getDoctypeColor WRITE setDoctypeColor NOTIFY doctypeColorChanged FINAL)
public:
    static CodeColors* instance(QObject* parent);

    QColor getDefaultColor() const;
    void setDefaultColor(const QColor &newDefaultColor);

    QColor getKeywordColor() const;
    void setKeywordColor(const QColor &newKeywordColor);

    QColor getFunctionColor() const;
    void setFunctionColor(const QColor &newFunctionColor);

    QColor getFunctionCallColor() const;
    void setFunctionCallColor(const QColor &newFunctionCallColor);

    QColor getCommentColor() const;
    void setCommentColor(const QColor &newCommentColor);

    QColor getStringColor() const;
    void setStringColor(const QColor &newStringColor);

    QColor getNumberColor() const;
    void setNumberColor(const QColor &newNumberColor);

    QColor getHeaderColor() const;
    void setHeaderColor(const QColor &newHeaderColor);

    QColor getBackgroundColor() const;
    void setBackgroundColor(const QColor &newBackgroundColor);

    QColor getPreprocessorColor() const;
    void setPreprocessorColor(const QColor &newPreprocessorColor);

    QColor getTypeColor() const;
    void setTypeColor(const QColor &newTypeColor);

    QColor getArrowColor() const;
    void setArrowColor(const QColor &newArrowColor);

    QColor getCommandColor() const;
    void setCommandColor(const QColor &newCommandColor);

    QColor getVariableColor() const;
    void setVariableColor(const QColor &newVariableColor);

    QColor getKeyColor() const;
    void setKeyColor(const QColor &newKeyColor);

    QColor getValueColor() const;
    void setValueColor(const QColor &newValueColor);

    QColor getParameterColor() const;
    void setParameterColor(const QColor &newParameterColor);

    QColor getAttributeNameColor() const;
    void setAttributeNameColor(const QColor &newAttributeNameColor);

    QColor getAttributeValueColor() const;
    void setAttributeValueColor(const QColor &newAttributeValueColor);

    QColor getSpecialCharacterColor() const;
    void setSpecialCharacterColor(const QColor &newSpecialCharacterColor);

    QColor getDoctypeColor() const;
    void setDoctypeColor(const QColor &newDoctypeColor);

signals:
    void defaultColorChanged();
    void keywordColorChanged();
    void functionColorChanged();
    void functionCallColorChanged();
    void commentColorChanged();
    void stringColorChanged();
    void numberColorChanged();
    void headerColorChanged();
    void backgroundColorChanged();
    void preprocessorColorChanged();
    void typeColorChanged();
    void arrowColorChanged();
    void commandColorChanged();
    void variableColorChanged();
    void keyColorChanged();
    void valueColorChanged();
    void parameterColorChanged();
    void attributeNameColorChanged();
    void attributeValueColorChanged();
    void specialCharacterColorChanged();
    void doctypeColorChanged();

private:
    static CodeColors* m_instance;

    explicit CodeColors(QObject* parent = nullptr);
    virtual ~CodeColors();

    QColor defaultColor = "#2e3440";
    QColor keywordColor = "#5e81ac";
    QColor functionColor = "#b48ead";
    QColor functionCallColor = "#88c0d0";
    QColor commentColor = "#a0a0a0";
    QColor stringColor = "#a3be8c";
    QColor numberColor = "#d08770";
    QColor headerColor = "#bf616a";
    QColor backgroundColor = "#eceff4";

    QColor preprocessorColor = keywordColor;
    QColor typeColor = numberColor;
    QColor arrowColor = functionColor;
    QColor commandColor = functionCallColor;
    QColor variableColor = numberColor;
    QColor keyColor = functionColor;
    QColor valueColor = stringColor;
    QColor parameterColor = stringColor;
    QColor attributeNameColor = numberColor;
    QColor attributeValueColor = stringColor;
    QColor specialCharacterColor = functionColor;
    QColor doctypeColor = commentColor;
};

#endif // CODECOLORS_H
