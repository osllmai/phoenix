#include "deepsearchconversation.h"

void DeepSearchConversation::classifyQuery() {

    QString classifyPrompt = R"(
        You are a classifier. Your job is to decide whether answering the user's question requires
        searching and retrieving up-to-date scientific papers from arXiv or other external sources.

        Guidelines:
        - If the question is about general knowledge, greetings, casual chat, opinions, or widely-known facts → answer: No
        - If the question is a scientific or technical research question that may require recent findings, formulas, datasets, or academic references → answer: Yes

        Output format:
        ONLY respond with exactly one word: "Yes" or "No"

        User Question:
        {{query}}

        Response:
    )";

    QString text_prompt = classifyPrompt;
    text_prompt.replace("{{query}}", m_userQuery);

    sendPromptForModel(text_prompt, false);
}

void DeepSearchConversation::generateClarificationQuestions() {

    QString clarifyPrompt = R"(
        You are an AI assistant specialized in scientific information retrieval.
        Your task is to ask the user clarifying questions ONLY if necessary to perform
        a more accurate scientific deep search.

        Rules:
        - If the user query is unclear, ambiguous, or too broad → ask 2 to 4 clarifying questions
        - If the query is already specific enough → respond with "NO_QUESTIONS_NEEDED"
        - Do NOT answer the original question here
        - Do NOT add explanations
        - Keep questions short and focused

        Output format:
        - If questions needed: each question as a bullet using "-"
        - If not needed: output exactly "NO_QUESTIONS_NEEDED"

        User Query:
        {{query}}

        Response:
    )";

    QString text_prompt = clarifyPrompt;
    text_prompt.replace("{{query}}", m_userQuery);

    sendPromptForModel(text_prompt, modelSettings()->stream());
}

void DeepSearchConversation::generateSearchKeywords() {

    QString keywordPrompt = R"(
        You are an AI system specialized in scientific information retrieval, trained on arXiv structure.

        Your task:
        Generate 5–8 **high-precision scientific search keywords** optimized for arXiv API queries.

        You must deeply analyze:
        • User query
        • Recent dialog context
        • True scientific intent and subfield
        • Relevant arXiv subject-class taxonomy

        === STRICT OUTPUT REQUIREMENTS ===
        Each keyword MUST:
        • Be a real scientific concept, model, architecture, method family, dataset, or mathematical construct
        • Use EXACT terminology found in arXiv papers (NO natural language)
        • Be 1–4 words ONLY
        • Avoid filler words:
          ("methods", "techniques", "approach", "system", "application", "introduction", "study", "analysis", "framework", "performance")
        • Avoid question patterns ("how to", "why", "which")
        • Avoid vague or generic words ("deep learning", "machine learning", "neural network")
        • Be highly discriminative

        === CATEGORY REQUIREMENTS ===
        Each keyword MUST be assigned a valid arXiv subject class that best matches it:
        Examples:
          cs.CL, cs.LG, cs.CV, cs.IR, cs.AI, stat.ML, math.IT, eess.AS, physics.optics, etc.

        === CONFIDENCE REQUIREMENTS ===
        • confidence ∈ [0.50, 1.00], representing concept relevance

        === INPUT CONTEXT ===
        User Query:
        {{query}}

        Conversation Context (last 2 messages):
        {{history_2}}

        === OUTPUT FORMAT (MANDATORY JSON ONLY) ===
        {
          "keywords": [
            {
              "term": "precise scientific keyword",
              "category": "arXivClass",
              "confidence": 0.0
            }
          ]
        }

        NO extra text. NO comments. NO explanations. JSON ONLY.
    )";



    keywordPrompt.replace("{{query}}", m_userQuery);

    QString history = messageList()->history(2);
    keywordPrompt.replace("{{history_2}}", history);

    sendPromptForModel(keywordPrompt, false);
}

void DeepSearchConversation::generateUserIntentSummary()
{
    QString prompt = R"(
        You are an AI assistant specialized in scientific information extraction.

        Your task:
        - Read the user's original query.
        - Read the user's answers to clarification questions (the last few messages).
        - Understand the true intent behind the user's scientific search.
        - Produce a **single, short, precise paragraph** that summarizes the user's actual goal.

        Rules:
        - The output MUST be 1 paragraph only.
        - No bullet points.
        - No explanations.
        - No greetings.
        - Scientific style, concise, embedding-friendly.
        - Focus on key concepts, constraints, domain, and purpose.
        - Avoid unnecessary filler text.

        Input:
        User Query:
        {{query}}

        Recent Conversation:
        {{history}}

        Output:
        (One short paragraph describing the user's exact information need)
    )";

    QString textPrompt = prompt;
    textPrompt.replace("{{query}}", m_userQuery);
    textPrompt.replace("{{history}}", messageList()->history(6));

    sendPromptForModel(textPrompt, false);
}

void DeepSearchConversation::generateDeepSearchAnswer()
{
    QStringList docBlocks;

    for (const QVariant &v : m_results) {
        QVariantMap m = v.toMap();

        QString block = QString(
                            "Title: %1\n"
                            "Link: %2\n"
                            "Similarity: %3\n"
                            "Extracted Text:\n%4\n"
                            ).arg(
                                m.value("title").toString(),
                                m.value("link").toString(),
                                QString::number(m.value("similarity").toDouble(), 'f', 2),
                                m.value("text").toString()
                                );

        docBlocks << block;
    }

    QString documentsSection = docBlocks.join("\n-------------------------\n");

    QString prompt = R"(You are an advanced scientific reasoning AI specialized in retrieval-augmented generation (RAG).
        Your task:
        - Read the user's query.
        - Carefully analyze the extracted high-similarity text chunks from scientific papers.
        - Based ONLY on these documents, generate the **best, most complete scientific answer** possible.
        - Your answer MUST be grounded in the provided documents, not general knowledge.
        - When referencing information, rely strictly on the provided text chunks.

        Output format (VERY IMPORTANT):

        Answer:
        A complete, detailed, high-quality scientific explanation answering the user's question.

        Sources:
        A numbered list of the papers used, each with:
        - Title
        - PDF link

        If a paper was not used, do not list it.

        #########################
        USER QUERY:
        {{query}}

        #########################
        DOCUMENT EXCERPTS:
        {{documents}}
    )";

    prompt.replace("{{query}}", m_userQuery);
    prompt.replace("{{documents}}", documentsSection);

    qCInfo(logDeepSearch) << "Sending DeepSearch RAG prompt to model.";

    sendPromptForModel(prompt, modelSettings()->stream());
}

void DeepSearchConversation::finalPrompt(){
    switch (m_selectedSources) {
    case DataSource::None:
        sendPromptForModel(m_userQuery, modelSettings()->stream());
        break;

    case DataSource::Arxiv:
        generateDeepSearchAnswer();
        break;
    default:
        qCWarning(logDeepSearch) << "Unhandled state in handleState.";
        break;
    }
}
