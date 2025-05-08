#ifndef MESSAGETEXTPROCESSOR_H
#define MESSAGETEXTPROCESSOR_H

#include <QObject>
#include <QQuickTextDocument>
#include <QSyntaxHighlighter>
#include <QTextCharFormat>
#include <QTextDocument>

class MessageTextProcessor : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QQuickTextDocument* textDocument READ textDocument WRITE setTextDocument NOTIFY textDocumentChanged)

public:
    explicit MessageTextProcessor(QObject *parent = nullptr);

    QQuickTextDocument* textDocument() const { return m_doc; }

    void setTextDocument(QQuickTextDocument* doc);

    Q_INVOKABLE void setValue(const QString &value);

signals:
    void textDocumentChanged();

private:
    QQuickTextDocument *m_doc = nullptr;
};

#endif // MESSAGETEXTPROCESSOR_H
