#include "highlightingcategory.h"

#include <QBrush>
#include <QColor>
#include <QFont>

QTextCharFormat highlightingCategory_To_QTextCharFormat(const HighlightingCategory highlightingCategory) {
    QTextCharFormat format;

    switch (highlightingCategory) {
    case Default:
        format.setForeground(Qt::black);
        break;

    case FunctionCall:
    case Function:
    case BuiltinFunction:
        format.setForeground(Qt::darkCyan);
        format.setFontItalic(true);
        break;

    case ClassName:
    case Type:
    case TypeAnnotation:
        format.setForeground(Qt::darkMagenta);
        format.setFontWeight(QFont::Bold);
        break;

    case Operator:
        format.setForeground(Qt::darkGray);
        break;

    case Number:
        format.setForeground(Qt::darkRed);
        break;

    case Keyword:
        format.setForeground(Qt::darkBlue);
        format.setFontWeight(QFont::Bold);
        break;

    case Constant:
    case Boolean:
    case Null:
        format.setForeground(Qt::blue);
        format.setFontWeight(QFont::Bold);
        break;

    case Annotation:
    case Cmdlet:
        format.setForeground(Qt::darkYellow);
        break;

    case String:
    case Value:
    case Attribute:
    case Property:
        format.setForeground(Qt::darkGreen);
        break;

    case Comment:
        format.setForeground(Qt::gray);
        format.setFontItalic(true);
        break;

    case Variable:
    case SpecialVariable:
        format.setForeground(Qt::darkBlue);
        break;

    case Tag:
    case ElementName:
        format.setForeground(QColor("#800000"));  // Brown
        format.setFontWeight(QFont::Bold);
        break;

    case Script:
    case Style:
    case Environment:
    case Code:
    case CodeBlock:
        format.setForeground(QColor("#005500"));  // Dark greenish
        format.setFontFamily("Courier");
        break;

    case Doctype:
    case Prolog:
        format.setForeground(Qt::darkGray);
        format.setFontItalic(true);
        break;

    case Section:
    case List:
    case ListItem:
        format.setForeground(Qt::black);
        format.setFontWeight(QFont::Bold);
        break;

    case Key:
    case Target:
    case TableColumn:
        format.setForeground(Qt::darkBlue);
        break;

    case Command:
        format.setForeground(Qt::darkRed);
        format.setFontWeight(QFont::Bold);
        break;

    case Math:
    case SpecialCharacter:
        format.setForeground(QColor("#990099"));  // Purple
        break;

    case Rule:
        format.setForeground(Qt::darkGreen);
        format.setFontItalic(true);
        break;

    case Link:
        format.setForeground(Qt::blue);
        format.setFontUnderline(true);
        break;

    case Bold:
        format.setFontWeight(QFont::Bold);
        break;

    case Italic:
        format.setFontItalic(true);
        break;

    case Date:
        format.setForeground(Qt::darkMagenta);
        break;

    default:
        format.setForeground(Qt::black);
        break;
    }

    return format;
}
