#ifndef SYNTAXHIGHLIGHTER_H
#define SYNTAXHIGHLIGHTER_H

#include <QColor>
#include <QObject>
#include <QQmlEngine>
#include <QQuickTextDocument> // IWYU pragma: keep
#include <QRectF>
#include <QSizeF>
#include <QString>
#include <QSyntaxHighlighter>
#include <QTextObjectInterface>
#include <QVector>

class QPainter;
class QTextDocument;
class QTextFormat;

struct CodeColors {
    Q_GADGET
    Q_PROPERTY(QColor defaultColor MEMBER defaultColor)
    Q_PROPERTY(QColor keywordColor MEMBER keywordColor)
    Q_PROPERTY(QColor functionColor MEMBER functionColor)
    Q_PROPERTY(QColor functionCallColor MEMBER functionCallColor)
    Q_PROPERTY(QColor commentColor MEMBER commentColor)
    Q_PROPERTY(QColor stringColor MEMBER stringColor)
    Q_PROPERTY(QColor numberColor MEMBER numberColor)
    Q_PROPERTY(QColor headerColor MEMBER headerColor)
    Q_PROPERTY(QColor backgroundColor MEMBER backgroundColor)

public:
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

Q_DECLARE_METATYPE(CodeColors)

class SyntaxHighlighter : public QSyntaxHighlighter {
    Q_OBJECT
public:
    SyntaxHighlighter(QObject *parent);
    ~SyntaxHighlighter();
    void highlightBlock(const QString &text) override;

    CodeColors codeColors() const { return m_codeColors; }
    void setCodeColors(const CodeColors &colors) { m_codeColors = colors; }

private:
    CodeColors m_codeColors;
};

struct ContextLink {
    int startPos = -1;
    int endPos = -1;
    QString text;
    QString href;
};

struct CodeCopy {
    int startPos = -1;
    int endPos = -1;
    QString text;
};

#endif // SYNTAXHIGHLIGHTER_H
