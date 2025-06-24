#include "messagetextprocessor.h"

MessageTextProcessor::MessageTextProcessor(QObject *parent)
    : QObject{parent}
    , m_quickTextDocument(nullptr)
    , m_syntaxHighlighter(new SyntaxHighlighter(this))
    , m_shouldProcessText(true)
    , m_fontPixelSize(QGuiApplication::font().pointSizeF())
{}

QQuickTextDocument* MessageTextProcessor::textDocument() const{return m_quickTextDocument;}
void MessageTextProcessor::setTextDocument(QQuickTextDocument* quickTextDocument){
    m_quickTextDocument = quickTextDocument;
    m_syntaxHighlighter->setDocument(m_quickTextDocument->textDocument());
    handleTextChanged();
}

void MessageTextProcessor::setValue(const QString &value){
    m_quickTextDocument->textDocument()->setPlainText(value);
    handleTextChanged();
}
bool MessageTextProcessor::tryCopyAtPosition(int position) const{
    for (const auto &copy : m_copies) {
        if (position >= copy.startPos && position <= copy.endPos) {
            QClipboard *clipboard = QGuiApplication::clipboard();
            clipboard->setText(copy.text);
            return true;
        }
    }
    return false;
}

bool MessageTextProcessor::shouldProcessText() const{return m_shouldProcessText;}
void MessageTextProcessor::setShouldProcessText(bool b){
    if (m_shouldProcessText == b)
        return;
    m_shouldProcessText = b;
    emit shouldProcessTextChanged();
    handleTextChanged();
}

qreal MessageTextProcessor::fontPixelSize() const{return m_fontPixelSize;}
void MessageTextProcessor::setFontPixelSize(qreal sz){
    if (m_fontPixelSize == sz)
        return;
    m_fontPixelSize = sz;
    emit fontPixelSizeChanged();
    handleTextChanged();
}

void traverseDocument(QTextDocument *doc, QTextFrame *frame){
    QTextFrame *rootFrame = frame ? frame : doc->rootFrame();
    QTextFrame::iterator rootIt;

    if (!frame)
        qDebug() << "Begin traverse";

    for (rootIt = rootFrame->begin(); !rootIt.atEnd(); ++rootIt) {
        QTextFrame *childFrame = rootIt.currentFrame();
        QTextBlock childBlock = rootIt.currentBlock();

        if (childFrame) {
            qDebug() << "Frame from" << childFrame->firstPosition() << "to" << childFrame->lastPosition();
            traverseDocument(doc, childFrame);
        } else if (childBlock.isValid()) {
            qDebug() << QString("    Block %1 position:").arg(childBlock.userState()) << childBlock.position();
            qDebug() << QString("    Block %1 text:").arg(childBlock.userState()) << childBlock.text();

            // Iterate over lines within the block
            for (QTextBlock::iterator blockIt = childBlock.begin(); !(blockIt.atEnd()); ++blockIt) {
                QTextFragment fragment = blockIt.fragment();
                if (fragment.isValid()) {
                    qDebug() << "    Fragment text:" << fragment.text();
                }
            }
        }
    }

    if (!frame)
        qDebug() << "End traverse";
}

void MessageTextProcessor::handleTextChanged(){
    if (!m_quickTextDocument || !m_shouldProcessText)
        return;

    // Force full layout of the text document to work around a bug in Qt
    // TODO(jared): report the Qt bug and link to the report here
    QTextDocument* doc = m_quickTextDocument->textDocument();
    (void)doc->documentLayout()->documentSize();

    handleCodeBlocks();
    handleMarkdown();

    // We insert an invisible char at the end to make sure the document goes back to the default
    // text format
    QTextCursor cursor(doc);
    QString invisibleCharacter = QString(QChar(0xFEFF));
    cursor.insertText(invisibleCharacter, QTextCharFormat());
}

void MessageTextProcessor::handleCodeBlocks(){
    QTextDocument* doc = m_quickTextDocument->textDocument();
    QTextCursor cursor(doc);

    QTextCharFormat textFormat;
    textFormat.setFontFamilies(QStringList() << "Monospace");
    textFormat.setForeground(QColor("white"));

    QTextFrameFormat frameFormatBase;
    frameFormatBase.setBackground(CodeColors::instance(this)->getBackgroundColor());

    QTextTableFormat tableFormat;
    tableFormat.setMargin(0);
    tableFormat.setPadding(0);
    tableFormat.setBorder(0);
    tableFormat.setBorderCollapse(true);
    QList<QTextLength> constraints;
    constraints << QTextLength(QTextLength::PercentageLength, 100);
    tableFormat.setColumnWidthConstraints(constraints);

    QTextTableFormat headerTableFormat;
    headerTableFormat.setBackground(CodeColors::instance(this)->getHeaderColor());
    headerTableFormat.setPadding(0);
    headerTableFormat.setBorder(0);
    headerTableFormat.setBorderCollapse(true);
    headerTableFormat.setTopMargin(10);
    headerTableFormat.setBottomMargin(10);
    headerTableFormat.setLeftMargin(15);
    headerTableFormat.setRightMargin(15);
    QList<QTextLength> headerConstraints;
    headerConstraints << QTextLength(QTextLength::PercentageLength, 80);
    headerConstraints << QTextLength(QTextLength::PercentageLength, 20);
    headerTableFormat.setColumnWidthConstraints(headerConstraints);

    QTextTableFormat codeBlockTableFormat;
    codeBlockTableFormat.setBackground(CodeColors::instance(this)->getBackgroundColor());
    codeBlockTableFormat.setPadding(0);
    codeBlockTableFormat.setBorder(0);
    codeBlockTableFormat.setBorderCollapse(true);
    codeBlockTableFormat.setTopMargin(15);
    codeBlockTableFormat.setBottomMargin(15);
    codeBlockTableFormat.setLeftMargin(15);
    codeBlockTableFormat.setRightMargin(15);
    codeBlockTableFormat.setColumnWidthConstraints(constraints);

    QTextImageFormat copyImageFormat;
    copyImageFormat.setWidth(24);
    copyImageFormat.setHeight(24);
    copyImageFormat.setName("qrc:/media/icon/copyFill.svg");

    // Regex for code blocks
    static const QRegularExpression reCode("```(.*?)(```|$)", QRegularExpression::DotMatchesEverythingOption);
    QRegularExpressionMatchIterator iCode = reCode.globalMatch(doc->toPlainText());

    QList<QRegularExpressionMatch> matchesCode;
    while (iCode.hasNext())
        matchesCode.append(iCode.next());

    QVector<CodeCopy> newCopies;
    QVector<QTextFrame*> frames;

    for(int index = matchesCode.count() - 1; index >= 0; --index) {
        cursor.setPosition(matchesCode[index].capturedStart());
        cursor.setPosition(matchesCode[index].capturedEnd(), QTextCursor::KeepAnchor);
        cursor.removeSelectedText();

        int startPos = cursor.position();

        QTextFrameFormat frameFormat = frameFormatBase;
        QString capturedText = matchesCode[index].captured(1);
        QString codeLanguage;

        QStringList lines = capturedText.split('\n');
        if (lines.last().isEmpty()) {
            lines.removeLast();
        }

        if (lines.count() >= 2) {
            const auto &firstWord = lines.first();
            if (firstWord == "python"
                || firstWord == "cpp"
                || firstWord == "c++"
                || firstWord == "csharp"
                || firstWord == "c#"
                || firstWord == "c"
                || firstWord == "bash"
                || firstWord == "javascript"
                || firstWord == "typescript"
                || firstWord == "java"
                || firstWord == "go"
                || firstWord == "golang"
                || firstWord == "json"
                || firstWord == "latex"
                || firstWord == "html"
                || firstWord == "php") {
                codeLanguage = firstWord;
            }
            lines.removeFirst();
        }

        QTextFrame *mainFrame = cursor.currentFrame();
        cursor.setCharFormat(textFormat);

        QTextFrame *frame = cursor.insertFrame(frameFormat);
        QTextTable *table = cursor.insertTable(codeLanguage.isEmpty() ? 1 : 2, 1, tableFormat);

        if (!codeLanguage.isEmpty()) {
            QTextTableCell headerCell = table->cellAt(0, 0);
            QTextCursor headerCellCursor = headerCell.firstCursorPosition();
            QTextTable *headerTable = headerCellCursor.insertTable(1, 2, headerTableFormat);
            QTextTableCell header = headerTable->cellAt(0, 0);
            QTextCursor headerCursor = header.firstCursorPosition();
            headerCursor.insertText(codeLanguage);
            QTextTableCell copy = headerTable->cellAt(0, 1);
            QTextCursor copyCursor = copy.firstCursorPosition();
            int startPos = copyCursor.position();
            CodeCopy newCopy;
            newCopy.text = lines.join("\n");
            newCopy.startPos = copyCursor.position();
            newCopy.endPos = newCopy.startPos + 1;
            newCopies.append(newCopy);
// FIXME: There are two reasons this is commented out. Odd drawing behavior is seen when this is added
// and one selects with the mouse the code language in a code block. The other reason is the code that
// tries to do a hit test for the image is just very broken and buggy and does not always work. So I'm
// disabling this code and included functionality for v3.0.0 until I can figure out how to make this much
// less buggy
#if 0
//            QTextBlockFormat blockFormat;
//            blockFormat.setAlignment(Qt::AlignRight);
//            copyCursor.setBlockFormat(blockFormat);
//            copyCursor.insertImage(copyImageFormat, QTextFrameFormat::FloatRight);
#endif
        }

        QTextTableCell codeCell = table->cellAt(codeLanguage.isEmpty() ? 0 : 1, 0);
        QTextCursor codeCellCursor = codeCell.firstCursorPosition();
        QTextTable *codeTable = codeCellCursor.insertTable(1, 1, codeBlockTableFormat);
        QTextTableCell code = codeTable->cellAt(0, 0);

        QTextCharFormat codeBlockCharFormat;
        codeBlockCharFormat.setForeground(CodeColors::instance(this)->getDefaultColor());

        QFont monospaceFont("Courier");
        monospaceFont.setPointSize(m_fontPixelSize);
        if (monospaceFont.family() != "Courier") {
            monospaceFont.setFamily("Monospace"); // Fallback if Courier isn't available
        }

        QTextCursor codeCursor = code.firstCursorPosition();
        codeBlockCharFormat.setFont(monospaceFont); // Update the font for the codeblock
        codeCursor.setCharFormat(codeBlockCharFormat);

        codeCursor.block().setUserState(stringToLanguage(codeLanguage));
        codeCursor.insertText(lines.join('\n'));

        cursor = mainFrame->lastCursorPosition();
        cursor.setCharFormat(QTextCharFormat());
    }

    m_copies = newCopies;
}

void replaceAndInsertMarkdown(int startIndex, int endIndex, QTextDocument *doc)
{
    QTextCursor cursor(doc);
    cursor.setPosition(startIndex);
    cursor.setPosition(endIndex, QTextCursor::KeepAnchor);
    QTextDocumentFragment fragment(cursor);
    const QString plainText = fragment.toPlainText();
    cursor.removeSelectedText();
    QTextDocument::MarkdownFeatures features = static_cast<QTextDocument::MarkdownFeatures>(
        QTextDocument::MarkdownNoHTML | QTextDocument::MarkdownDialectGitHub);
    cursor.insertMarkdown(plainText, features);
    cursor.block().setUserState(Markdown);
}

void MessageTextProcessor::handleMarkdown()
{
    QTextDocument* doc = m_quickTextDocument->textDocument();
    QTextCursor cursor(doc);

    QVector<QPair<int, int>> codeBlockPositions;

    QTextFrame *rootFrame = doc->rootFrame();
    QTextFrame::iterator rootIt;

    bool hasAlreadyProcessedMarkdown = false;
    for (rootIt = rootFrame->begin(); !rootIt.atEnd(); ++rootIt) {
        QTextFrame *childFrame = rootIt.currentFrame();
        QTextBlock childBlock = rootIt.currentBlock();
        if (childFrame) {
            codeBlockPositions.append(qMakePair(childFrame->firstPosition()-1, childFrame->lastPosition()+1));

            for (QTextFrame::iterator frameIt = childFrame->begin(); !frameIt.atEnd(); ++frameIt) {
                QTextBlock block = frameIt.currentBlock();
                if (block.isValid() && block.userState() == Markdown)
                    hasAlreadyProcessedMarkdown = true;
            }
        } else if (childBlock.isValid() && childBlock.userState() == Markdown)
            hasAlreadyProcessedMarkdown = true;
    }


    if (!hasAlreadyProcessedMarkdown) {
        std::sort(codeBlockPositions.begin(), codeBlockPositions.end(), [](const QPair<int, int> &a, const QPair<int, int> &b) {
            return a.first > b.first;
        });

        int lastIndex = doc->characterCount() - 1;
        for (const auto &pos : codeBlockPositions) {
            int nonCodeStart = pos.second;
            int nonCodeEnd = lastIndex;
            if (nonCodeEnd > nonCodeStart) {
                replaceAndInsertMarkdown(nonCodeStart, nonCodeEnd, doc);
            }
            lastIndex = pos.first;
        }

        if (lastIndex > 0)
            replaceAndInsertMarkdown(0, lastIndex, doc);
    }
}

