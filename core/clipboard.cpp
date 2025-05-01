#include "clipboard.h"
#include <QGuiApplication>
#include <QClipboard>

Clipboard::Clipboard(QObject *parent) : QObject(parent) {}

void Clipboard::copyText(const QString &text)
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    if (clipboard)
        clipboard->setText(text);
}
