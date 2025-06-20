#ifndef MESSAGETEXTPROCESSOR_H
#define MESSAGETEXTPROCESSOR_H

// #include <QObject>
// #include <QQuickTextDocument>
// #include <QSyntaxHighlighter>
// #include <QTextCharFormat>
// #include <QTextDocument>

// class MessageTextProcessor : public QObject {
//     Q_OBJECT
//     QML_ELEMENT
//     Q_PROPERTY(QQuickTextDocument* textDocument READ textDocument WRITE setTextDocument NOTIFY textDocumentChanged)

// public:
//     explicit MessageTextProcessor(QObject *parent = nullptr);

//     QQuickTextDocument* textDocument() const { return m_doc; }

//     void setTextDocument(QQuickTextDocument* doc);

//     Q_INVOKABLE void setValue(const QString &value);

// signals:
//     void textDocumentChanged();

// private:
//     QQuickTextDocument *m_doc = nullptr;
// };



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


class ChatViewTextProcessor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQuickTextDocument* textDocument READ textDocument WRITE setTextDocument NOTIFY textDocumentChanged())
    Q_PROPERTY(bool shouldProcessText READ shouldProcessText WRITE setShouldProcessText NOTIFY shouldProcessTextChanged())
    Q_PROPERTY(qreal fontPixelSize READ fontPixelSize WRITE setFontPixelSize NOTIFY fontPixelSizeChanged())
    Q_PROPERTY(CodeColors codeColors READ codeColors WRITE setCodeColors NOTIFY codeColorsChanged())
    QML_ELEMENT
public:
    explicit ChatViewTextProcessor(QObject *parent = nullptr);

    QQuickTextDocument* textDocument() const;
    void setTextDocument(QQuickTextDocument* textDocument);

    Q_INVOKABLE void setValue(const QString &value);
    Q_INVOKABLE bool tryCopyAtPosition(int position) const;

    bool shouldProcessText() const;
    void setShouldProcessText(bool b);

    qreal fontPixelSize() const;
    void setFontPixelSize(qreal b);

    CodeColors codeColors() const;
    void setCodeColors(const CodeColors &colors);

Q_SIGNALS:
    void textDocumentChanged();
    void shouldProcessTextChanged();
    void fontPixelSizeChanged();
    void codeColorsChanged();

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
