#include "batchhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> batchHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Keywords
        QStringList keywords = {
            "\\bif\\b", "\\belse\\b", "\\bnot\\b", "\\bexist\\b", "\\bdefined\\b",
            "\\bgoto\\b", "\\bcall\\b", "\\bset\\b", "\\bexit\\b", "\\bfor\\b",
            "\\bin\\b", "\\bdo\\b", "\\bshift\\b", "\\bchoice\\b", "\\bpause\\b"
        };
        for (const QString &pattern : keywords) {
            rule.pattern = QRegularExpression(pattern, QRegularExpression::CaseInsensitiveOption);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Variables like %VAR% or !VAR!
        rule.pattern = QRegularExpression("%\\w+%|!\\w+!");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Labels (e.g., :label)
        rule.pattern = QRegularExpression("^:\\w+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Annotation);
        highlightingRules.append(rule);

        // Strings
        rule.pattern = QRegularExpression("\"[^\"]*\"");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments starting with REM or ::
        rule.pattern = QRegularExpression("(^|\\s)(REM\\s.*|::.*)", QRegularExpression::CaseInsensitiveOption);
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Numbers
        rule.pattern = QRegularExpression("\\b\\d+\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Operators
        QStringList operators = {
            "==", "\\|", "&", ">", "<", ">>", "<<", "\\+"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
