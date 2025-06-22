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
            format.setForeground(formatToColor(rule.format, m_codeColors));
            setFormat(startIndex, length, format);
        }
    }
}

QColor SyntaxHighlighter::formatToColor(HighlightingCategory highlightingCategory, const CodeColors &colors)
{
    switch (highlightingCategory) {
    case Default:           return QColor("#2e3440"); // Main text
    case Keyword:           return QColor("#5e81ac"); // Blue
    case Function:          return QColor("#b48ead"); // Purple
    case FunctionCall:      return QColor("#88c0d0"); // Cyan
    case Comment:           return QColor("#a0a0a0"); // Light gray
    case String:            return QColor("#a3be8c"); // Green
    case Number:            return QColor("#d08770"); // Orange
    // case Header:            return QColor("#bf616a"); // Red
    // case Preprocessor:      return QColor("#8fbcbb"); // Teal
    case Type:              return QColor("#81a1c1"); // Light blue
    // case Arrow:             return QColor("#b48ead"); // Purple
    case Command:           return QColor("#ebcb8b"); // Yellow
    case Variable:          return QColor("#d8dee9"); // White-ish
    case Key:               return QColor("#5e81ac"); // Blue
    case Value:             return QColor("#a3be8c"); // Green
    // case Parameter:         return QColor("#d08770"); // Orange
    // case AttributeName:     return QColor("#b48ead"); // Purple
    // case AttributeValue:    return QColor("#a3be8c"); // Green
    case SpecialCharacter:  return QColor("#d08770"); // Orange
    // case DocType:           return QColor("#8fbcbb"); // Teal
    default:
        Q_UNREACHABLE();
    }
    return QColor();
}
