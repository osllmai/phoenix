#include "highlighting.h"

#include "highlightingcategory.h"
#include "languageHighlightingRules/pythonhighlightingrules.h"

QVector<HighlightingRule> Highlighting::python() {
    return pythonHighlightingRules();
}

QVector<HighlightingRule> Highlighting::csharp() { return {}; }
QVector<HighlightingRule> Highlighting::cpp() { return {}; }
QVector<HighlightingRule> Highlighting::typescript() { return {}; }
QVector<HighlightingRule> Highlighting::java() { return {}; }
QVector<HighlightingRule> Highlighting::go() { return {}; }
QVector<HighlightingRule> Highlighting::bash() { return {}; }
QVector<HighlightingRule> Highlighting::latex() { return {}; }
QVector<HighlightingRule> Highlighting::html() { return {}; }
QVector<HighlightingRule> Highlighting::php() { return {}; }
QVector<HighlightingRule> Highlighting::json() { return {}; }
QVector<HighlightingRule> Highlighting::javascript() { return {}; }
QVector<HighlightingRule> Highlighting::markdown() { return {}; }
QVector<HighlightingRule> Highlighting::swift() { return {}; }
QVector<HighlightingRule> Highlighting::kotlin() { return {}; }
QVector<HighlightingRule> Highlighting::rust() { return {}; }
QVector<HighlightingRule> Highlighting::ruby() { return {}; }
QVector<HighlightingRule> Highlighting::sql() { return {}; }
QVector<HighlightingRule> Highlighting::r() { return {}; }
QVector<HighlightingRule> Highlighting::perl() { return {}; }
QVector<HighlightingRule> Highlighting::scala() { return {}; }
QVector<HighlightingRule> Highlighting::haskell() { return {}; }
QVector<HighlightingRule> Highlighting::lua() { return {}; }
QVector<HighlightingRule> Highlighting::assembly() { return {}; }

QVector<HighlightingRule> Highlighting::cmake() { return {}; }
QVector<HighlightingRule> Highlighting::makefile() { return {}; }
QVector<HighlightingRule> Highlighting::qml() { return {}; }
QVector<HighlightingRule> Highlighting::ini() { return {}; }
QVector<HighlightingRule> Highlighting::yaml() { return {}; }
QVector<HighlightingRule> Highlighting::dockerfile() { return {}; }
QVector<HighlightingRule> Highlighting::batch() { return {}; }
QVector<HighlightingRule> Highlighting::powershell() { return {}; }
QVector<HighlightingRule> Highlighting::shellscript() { return {}; }

QVector<HighlightingRule> Highlighting::xml() { return {}; }
QVector<HighlightingRule> Highlighting::css() { return {}; }
QVector<HighlightingRule> Highlighting::csv() { return {}; }
QVector<HighlightingRule> Highlighting::toml() { return {}; }

QTextCharFormat Highlighting::highlightingCategory_To_QTextCharFormat(const HighlightingCategory highlightingCategory) {
    QTextCharFormat format;
    return format;
}
