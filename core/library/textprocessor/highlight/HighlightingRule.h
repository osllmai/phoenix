#ifndef HIGHLIGHTINGRULE_H
#define HIGHLIGHTINGRULE_H

#include <QRegularExpression>
#include <QTextCharFormat>
#include "HighlightingCategory.h"

struct HighlightingRule {
    QRegularExpression pattern;
    HighlightingCategory format;
};

#endif // HIGHLIGHTINGRULE_H
