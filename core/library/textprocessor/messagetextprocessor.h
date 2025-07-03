#ifndef MESSAGETEXTPROCESSOR_H
#define MESSAGETEXTPROCESSOR_H

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
#include <QBrush>
#include <QChar>
#include <QClipboard>
#include <QFont>
#include <QFontMetricsF>
#include <QGuiApplication>
#include <QList>
#include <QPainter>
#include <QRegularExpression>
#include <QStringList>
#include <QTextBlock>
#include <QTextCharFormat>
#include <QTextCursor>
#include <QTextDocument>
#include <QTextDocumentFragment>
#include <QTextFrame>
#include <QTextFrameFormat>
#include <QTextTableCell>
#include <QVariant>
#include <Qt>
#include <QtGlobal>

#include <algorithm>

#include "language.h"
#include "syntaxhighlighter.h"
#include "codecolors.h"

class QPainter;
class QTextDocument;
class QTextFormat;

class MessageTextProcessor : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QQuickTextDocument* textDocument READ textDocument WRITE setTextDocument NOTIFY textDocumentChanged())
    Q_PROPERTY(bool shouldProcessText READ shouldProcessText WRITE setShouldProcessText NOTIFY shouldProcessTextChanged())
    Q_PROPERTY(qreal fontPixelSize READ fontPixelSize WRITE setFontPixelSize NOTIFY fontPixelSizeChanged())

public:
    explicit MessageTextProcessor(QObject *parent = nullptr);

    QQuickTextDocument* textDocument() const;
    void setTextDocument(QQuickTextDocument* textDocument);

    Q_INVOKABLE void setValue(const QString &value);
    Q_INVOKABLE bool tryCopyAtPosition(int position) const;

    bool shouldProcessText() const;
    void setShouldProcessText(bool b);

    qreal fontPixelSize() const;
    void setFontPixelSize(qreal b);

Q_SIGNALS:
    void textDocumentChanged();
    void shouldProcessTextChanged();
    void fontPixelSizeChanged();

private Q_SLOTS:
    void handleTextChanged();
    void handleCodeBlocks();
    void handleMarkdown();

private:
    QQuickTextDocument *m_quickTextDocument;
    SyntaxHighlighter *m_syntaxHighlighter;
    QVector<ContextLink> m_links;
    QVector<CodeCopy> m_copies;
    bool m_shouldProcessText = false;
    qreal m_fontPixelSize;
};


#endif // MESSAGETEXTPROCESSOR_H
