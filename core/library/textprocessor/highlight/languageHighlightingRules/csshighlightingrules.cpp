#include "csshighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> cssHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // CSS Properties (e.g., color, margin)
        QStringList properties = {
            "color", "background", "margin", "padding", "font", "border",
            "width", "height", "display", "position", "top", "left", "right", "bottom",
            "z-index", "overflow", "visibility", "text-align", "align-items",
            "justify-content", "flex", "grid", "animation", "transition", "opacity"
        };
        for (const QString &prop : properties) {
            rule.pattern = QRegularExpression(QString("\\b%1\\b").arg(prop));
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // CSS Values (e.g., auto, block, flex, etc.)
        QStringList values = {
            "auto", "block", "inline", "flex", "grid", "none", "solid", "relative", "absolute",
            "fixed", "hidden", "visible", "inherit", "initial", "unset"
        };
        for (const QString &val : values) {
            rule.pattern = QRegularExpression(QString("\\b%1\\b").arg(val));
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Constant);
            highlightingRules.append(rule);
        }

        // Numeric values with units (e.g., 10px, 2em)
        rule.pattern = QRegularExpression(R"(\b\d+(px|em|rem|vh|vw|%)\b)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Hex colors (e.g., #fff or #aabbcc)
        rule.pattern = QRegularExpression(R"(#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{6}))");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Class selectors (.className)
        rule.pattern = QRegularExpression(R"(\.[a-zA-Z_][\w\-]*)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // ID selectors (#idName)
        rule.pattern = QRegularExpression(R"(#[a-zA-Z_][\w\-]*)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Function);
        highlightingRules.append(rule);

        // At-rules (@media, @import)
        rule.pattern = QRegularExpression(R"(@[a-zA-Z\-]+)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Annotation);
        highlightingRules.append(rule);

        // Comments (/* ... */)
        rule.pattern = QRegularExpression(R"(/\*[\s\S]*?\*/)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Strings
        rule.pattern = QRegularExpression(R"(".*?")");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression(R"('.*?')");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);
    }

    return highlightingRules;
}
