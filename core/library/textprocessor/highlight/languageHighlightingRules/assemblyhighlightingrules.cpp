#include "assemblyhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> assemblyHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for any unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = HighlightingCategory::Default;
        highlightingRules.append(rule);

        // Instructions (assembly keywords)
        QStringList instructions = {
            "\\bmov\\b", "\\badd\\b", "\\bsub\\b", "\\bmul\\b", "\\bdiv\\b",
            "\\binc\\b", "\\bdec\\b", "\\band\\b", "\\bor\\b", "\\bxor\\b",
            "\\bnot\\b", "\\bsar\\b", "\\bshr\\b", "\\bshl\\b", "\\bcmp\\b",
            "\\bpush\\b", "\\bpop\\b", "\\bcall\\b", "\\bret\\b", "\\bint\\b",
            "\\bjmp\\b", "\\bje\\b", "\\bjne\\b", "\\bjg\\b", "\\bjl\\b",
            "\\bloop\\b"
        };
        for (const QString &pattern : instructions) {
            rule.pattern = QRegularExpression(pattern, QRegularExpression::CaseInsensitiveOption);
            rule.format = HighlightingCategory::Keyword;
            highlightingRules.append(rule);
        }

        // Registers
        QStringList registers = {
            "\\beax\\b", "\\bebx\\b", "\\becx\\b", "\\bedx\\b",
            "\\besi\\b", "\\bedi\\b", "\\besp\\b", "\\bebp\\b",
            "\\bal\\b", "\\bbl\\b", "\\bcl\\b", "\\bdl\\b",
            "\\bah\\b", "\\bbh\\b", "\\bch\\b", "\\bdh\\b"
        };
        for (const QString &pattern : registers) {
            rule.pattern = QRegularExpression(pattern, QRegularExpression::CaseInsensitiveOption);
            rule.format = (HighlightingCategory::Constant);
            highlightingRules.append(rule);
        }

        // Labels (e.g., label:)
        rule.pattern = QRegularExpression("^\\s*(\\w+):");
        rule.format = (HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Comments (; comment)
        rule.pattern = QRegularExpression(";[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Hexadecimal numbers
        rule.pattern = QRegularExpression("\\b0x[0-9A-Fa-f]+\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Decimal numbers
        rule.pattern = QRegularExpression("\\b\\d+\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Strings
        rule.pattern = QRegularExpression("\".*?\"");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Directives (e.g., .data, segment)
        QStringList directives = {
            "\\.data", "\\.text", "\\.bss", "\\bsegment\\b", "\\bends\\b", "\\bglobal\\b"
        };
        for (const QString &pattern : directives) {
            rule.pattern = QRegularExpression(pattern, QRegularExpression::CaseInsensitiveOption);
            rule.format = (HighlightingCategory::Annotation);
            highlightingRules.append(rule);
        }

        // Operators
        QStringList operators = {
            "\\+", "-", "\\*", "/", "\\[", "\\]"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
