#ifndef HIGHLIGHTING_H
#define HIGHLIGHTING_H

#include <QRegularExpression>
#include <QTextCharFormat>
#include <QVector>
#include "highlightingrule.h"

namespace Highlighting {

QVector<HighlightingRule> python();
QVector<HighlightingRule> csharp();
QVector<HighlightingRule> cpp();
QVector<HighlightingRule> typescript();
QVector<HighlightingRule> java();
QVector<HighlightingRule> go();
QVector<HighlightingRule> bash();
QVector<HighlightingRule> latex();
QVector<HighlightingRule> html();
QVector<HighlightingRule> php();
QVector<HighlightingRule> json();
QVector<HighlightingRule> javascript();
QVector<HighlightingRule> markdown();
QVector<HighlightingRule> swift();
QVector<HighlightingRule> kotlin();
QVector<HighlightingRule> rust();
QVector<HighlightingRule> ruby();
QVector<HighlightingRule> sql();
QVector<HighlightingRule> r();
QVector<HighlightingRule> perl();
QVector<HighlightingRule> scala();
QVector<HighlightingRule> haskell();
QVector<HighlightingRule> lua();
QVector<HighlightingRule> assembly();

QVector<HighlightingRule> cmake();
QVector<HighlightingRule> makefile();
QVector<HighlightingRule> qml();
QVector<HighlightingRule> ini();
QVector<HighlightingRule> yaml();
QVector<HighlightingRule> dockerfile();
QVector<HighlightingRule> batch();
QVector<HighlightingRule> powershell();
QVector<HighlightingRule> shellscript();

QVector<HighlightingRule> xml();
QVector<HighlightingRule> css();
QVector<HighlightingRule> csv();
QVector<HighlightingRule> toml();

QTextCharFormat formatFor(const QString& type);
}

#endif // HIGHLIGHTING_H
