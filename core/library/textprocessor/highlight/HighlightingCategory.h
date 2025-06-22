#ifndef HIGHLIGHTINGCATEGORY_H
#define HIGHLIGHTINGCATEGORY_H

#include <QRegularExpression>
#include <QTextCharFormat>

enum HighlightingCategory {
    Default,
    FunctionCall,
    Function,
    ClassName,
    BuiltinFunction,
    Operator,
    Number,
    Keyword,
    Constant,
    Annotation,
    String,
    Comment,
    Variable,
    Tag,
    Attribute,
    Value,
    Script,
    Style,
    Doctype,
    Section,
    Key,
    Type,
    Command,
    Math,
    Environment,
    SpecialCharacter,
    Target,
    Rule,
    Link,
    Bold,
    Italic,
    List,
    CodeBlock,
    Code,
    Cmdlet,
    ElementName,
    Property,
    SpecialVariable,
    TableColumn,
    TypeAnnotation,
    Date,
    Boolean,
    Prolog,
    Null,
    ListItem
};

#endif // HIGHLIGHTINGCATEGORY_H
