#include "syntaxhighlighter.h"

SyntaxHighlighter::SyntaxHighlighter(QObject *parent)
    : QSyntaxHighlighter(parent)
{}

SyntaxHighlighter::~SyntaxHighlighter()
{}

void SyntaxHighlighter::highlightBlock(const QString &text){
    QTextBlock block = this->currentBlock();

    // Search the first block of the frame we're in for the code to use for highlighting
    int userState = block.userState();
    if (QTextFrame *frame = block.document()->frameAt(block.position())) {
        QTextBlock firstBlock = frame->begin().currentBlock();
        if (firstBlock.isValid())
            userState = firstBlock.userState();
    }

    QVector<HighlightingRule> rules;
    switch (userState) {
    case Language::Python:
        rules = Highlighting::python(); break;
    case Language::Cpp:
        rules = Highlighting::cpp(); break;
    case Language::Csharp:
        rules = Highlighting::csharp(); break;
    case Language::Bash:
        rules = Highlighting::bash(); break;
    case Language::TypeScript:
        rules = Highlighting::typescript(); break;
    case Language::Java:
        rules = Highlighting::java(); break;
    case Language::Go:
        rules = Highlighting::go(); break;
    case Language::Json:
        rules = Highlighting::json(); break;
    case Language::Latex:
        rules = Highlighting::latex(); break;
    case Language::Html:
        rules = Highlighting::html(); break;
    case Language::Php:
        rules = Highlighting::php(); break;
    default: break;
    }

    for (const HighlightingRule &rule : std::as_const(rules)) {
        QRegularExpressionMatchIterator matchIterator = rule.pattern.globalMatch(text);
        while (matchIterator.hasNext()) {
            QRegularExpressionMatch match = matchIterator.next();
            int startIndex = match.capturedStart();
            int length = match.capturedLength();
            QTextCharFormat format;
            format.setForeground(formatToColor(rule.format));
            setFormat(startIndex, length, format);
        }
    }
}

QColor SyntaxHighlighter::formatToColor(HighlightingCategory highlightingCategory)
{
    switch (highlightingCategory) {
    case Default: return CodeColors::instance(nullptr)->getDefaultColor(); // Main text
    case Keyword: return CodeColors::instance(nullptr)->getKeywordColor(); // Blue
    case Function: return CodeColors::instance(nullptr)->getFunctionColor(); // Purple
    case FunctionCall: return CodeColors::instance(nullptr)->getFunctionCallColor(); // Cyan
    case Comment: return CodeColors::instance(nullptr)->getCommentColor(); // Light gray
    case String: return CodeColors::instance(nullptr)->getStringColor(); // Green
    case Number: return CodeColors::instance(nullptr)->getNumberColor(); // Orange
    // case Header: return QColor("#bf616a"); // Red
    // case Preprocessor: return QColor("#8fbcbb"); // Teal
    case Type: return CodeColors::instance(nullptr)->getTypeColor(); // Light blue
    // case Arrow: return QColor("#b48ead"); // Purple
    case Command: return CodeColors::instance(nullptr)->getCommandColor(); // Yellow
    case Variable: return CodeColors::instance(nullptr)->getVariableColor(); // White-ish
    case Key: return CodeColors::instance(nullptr)->getKeyColor(); // Blue
    case Value: return CodeColors::instance(nullptr)->getValueColor(); // Green
    // case Parameter: return QColor("#d08770"); // Orange
    // case AttributeName: return QColor("#b48ead"); // Purple
    // case AttributeValue: return QColor("#a3be8c"); // Green
    case SpecialCharacter: return CodeColors::instance(nullptr)->getSpecialCharacterColor(); // Orange
    // case DocType: return QColor("#8fbcbb"); // Teal
    default:
        Q_UNREACHABLE();
    }
    return QColor();
}
