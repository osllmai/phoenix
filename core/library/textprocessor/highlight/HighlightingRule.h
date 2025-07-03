#ifndef HIGHLIGHTINGRULE_H
#define HIGHLIGHTINGRULE_H

#include <QRegularExpression>
#include <QTextCharFormat>
#include "highlightingcategory.h"

struct HighlightingRule {
    QRegularExpression pattern;
    HighlightingCategory format;
};

#endif // HIGHLIGHTINGRULE_H
