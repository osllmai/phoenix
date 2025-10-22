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

#include "HighlightingRule.h"
#include "highlighting.h"
#include "HighlightingCategory.h"
#include "language.h"
#include "codecolors.h"

class QPainter;
class QTextDocument;
class QTextFormat;

class SyntaxHighlighter : public QSyntaxHighlighter {
    Q_OBJECT
public:
    SyntaxHighlighter(QObject *parent);
    ~SyntaxHighlighter();
    void highlightBlock(const QString &text) override;

private:
    static QColor formatToColor(HighlightingCategory highlightingCategory);
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
