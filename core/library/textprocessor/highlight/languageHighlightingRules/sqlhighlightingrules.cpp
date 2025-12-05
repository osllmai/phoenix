#include "sqlhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> sqlHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // SQL keywords (e.g., SELECT, INSERT, UPDATE, DELETE, WHERE, etc.)
        QStringList keywordPatterns = {
            "\\bSELECT\\b", "\\bFROM\\b", "\\bWHERE\\b", "\\bINSERT\\b", "\\bINTO\\b", "\\bVALUES\\b",
            "\\bUPDATE\\b", "\\bDELETE\\b", "\\bJOIN\\b", "\\bON\\b", "\\bAND\\b", "\\bOR\\b",
            "\\bGROUP\\b", "\\bBY\\b", "\\bORDER\\b", "\\bHAVING\\b", "\\bDISTINCT\\b", "\\bLIMIT\\b",
            "\\bUNION\\b", "\\bALTER\\b", "\\bCREATE\\b", "\\bDROP\\b", "\\bTRUNCATE\\b", "\\bRENAME\\b",
            "\\bTABLE\\b", "\\bINDEX\\b", "\\bVIEW\\b", "\\bDATABASE\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // String literals (e.g., 'This is a string')
        rule.pattern = QRegularExpression("'[^']*'");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Number literals (e.g., 123, 45.67)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Comments (single-line comments starting with -- and multi-line comments using /* */)
        rule.pattern = QRegularExpression("--[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression("/\\*[^*]*\\*+(?:[^/*][^*]*\\*+)*/");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Operators (e.g., =, <, >, !=, AND, OR, LIKE, IN, etc.)
        QStringList operators = {
            "\\=", "\\<", "\\>", "\\!\\=", "\\bAND\\b", "\\bOR\\b", "\\bLIKE\\b", "\\bIN\\b",
            "\\bBETWEEN\\b", "\\bIS\\b", "\\bNULL\\b"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Table and column names (e.g., table_name, column_name)
        rule.pattern = QRegularExpression("\\b[a-zA-Z_][a-zA-Z0-9_]*\\b");
        rule.format = (HighlightingCategory::TableColumn);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
