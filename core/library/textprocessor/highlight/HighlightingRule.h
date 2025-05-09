#ifndef HIGHLIGHTINGRULE_H
#define HIGHLIGHTINGRULE_H

#include <QRegularExpression>
#include <QTextCharFormat>

struct HighlightingRule {
    QRegularExpression pattern;
    QTextCharFormat format;
};

#endif // HIGHLIGHTINGRULE_H
