#include "luahighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> luaHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Lua keywords (e.g., if, then, end, for, etc.)
        QStringList keywordPatterns = {
            "\\bif\\b", "\\bthen\\b", "\\bend\\b", "\\bfor\\b", "\\bin\\b",
            "\\bwhile\\b", "\\brepeat\\b", "\\buntil\\b", "\\bdo\\b", "\\bfunction\\b",
            "\\blocal\\b", "\\breturn\\b", "\\bnil\\b", "\\btrue\\b", "\\bfalse\\b",
            "\\bnot\\b", "\\band\\b", "\\bor\\b", "\\bxor\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Lua functions (e.g., print(), table.insert())
        rule.pattern = QRegularExpression("\\b\\w+\\s*(?=\\()");
        rule.format = (HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // Lua variable names (e.g., x, myVariable)
        rule.pattern = QRegularExpression("\\b[a-zA-Z_][a-zA-Z0-9_]*\\b");
        rule.format = (HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Lua operators (e.g., +, -, *, /, ==, ~=)
        QStringList operators = {
            "\\+","\\-","\\*","\\/","\\%","\\=\\=","\\!\\=","\\&\\&","\\|\\|"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Numeric literals (e.g., 123, 3.14)
        rule.pattern = QRegularExpression("\\b[0-9]+\\.?[0-9]*\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Strings (single-quoted and double-quoted)
        rule.pattern = QRegularExpression("'[^']*'|\"[^\"]*\"");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line with --)
        rule.pattern = QRegularExpression("--[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
