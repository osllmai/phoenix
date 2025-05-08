#include "messagetextprocessor.h"
#include <QTextCharFormat>
#include <QBrush>
#include <QColor>

MessageTextProcessor::MessageTextProcessor(QObject *parent)
    : QObject(parent)
{}

void MessageTextProcessor::setTextDocument(QQuickTextDocument* doc) {
    if (m_doc == doc) return;
    m_doc = doc;
    emit textDocumentChanged();
}

void MessageTextProcessor::setValue(const QString &value) {
    if (m_doc && m_doc->textDocument()) {
        m_doc->textDocument()->setPlainText(value);
    }
}
