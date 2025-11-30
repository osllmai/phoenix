#ifndef DEEPSEARCHCONVERSATION_H
#define DEEPSEARCHCONVERSATION_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

#include "../../model/modelsettings.h"
#include "../chat/messagelist.h"
#include "../../model/model.h"
#include "../../model/offline/offlinemodellist.h"
#include "../../model/online/onlinemodellist.h"
#include "../../model/online/onlinecompanylist.h"
#include "../../model/online/onlinecompany.h"
#include "../../provider/provider.h"
#include "../conversation.h"

#include <QLoggingCategory>
#include "logcategories.h"

class DeepSearchConversation : public Conversation
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit DeepSearchConversation(QObject* parent = nullptr)
        : Conversation(parent) {}

    explicit DeepSearchConversation(int id, const QString &title, const QString &description,
                              const QString &icon,  const QString type, const QDateTime &date, const bool isPinned,
                              QObject *parent = nullptr);

    explicit DeepSearchConversation(int id, const QString &title, const QString &description,
                              const QString &icon,  const QString type, const QDateTime &date, const bool isPinned,
                              const bool &stream, const QString &promptTemplate,
                              const QString &systemPrompt, const double &temperature,
                              const int &topK, const double &topP, const double &minP,
                              const double &repeatPenalty, const int &promptBatchSize,
                              const int &maxTokens, const int &repeatPenaltyTokens,
                              const int &contextLength, const int &numberOfGPULayers,
                              QObject *parent = nullptr);

    virtual ~DeepSearchConversation();

    enum class DeepSearchState {
        WaitingPrompt,       // Waiting for user prompt
        LoadModel,           // Loading local model
        ClassifyQuery,       // Classify user's query: local answer or external search needed?
        // DecideSources,       // Decide which external sources should be used (arXiv, Web, Local Docs)
        SearchInSources,     // Perform search in selected sources
        DownloadDocuments,   // Download necessary documents (e.g., PDFs from results)
        PdfTokenizer,        // Extract text / tokenize downloaded documents
        RAGPreparation,      // Retrieve relevant chunks & prepare context prompt for LLM (RAG)
        SendForTextModel,    // Send final combined prompt to language model
        Finished             // Final response completed and conversation state reset
    };

    enum class DataSource {
        None,
        LocalDocs,
        Arxiv,
        Web
    };

    Q_INVOKABLE void readMessages();
    Q_INVOKABLE void prompt(const QString &input, const QString &fileName, const QString &fileInfo);
    Q_INVOKABLE void stop();
    Q_INVOKABLE void loadModel(const int id);
    Q_INVOKABLE void unloadModel();

    void likeMessageRequest(const int messageId, const int like);

    void addMessage(const int id, const QString &text, const QString &fileName, QDateTime date,
                    const QString &icon, bool isPrompt, const int like);

public slots:
    void loadModelResult(const bool result, const QString &warning);
    void tokenResponse(const QString &token);
    void finishedResponse(const QString &warning);
    void updateModelSettingsConversation();

private:
    void handleState();
    void classifyQuery();
    void finalPrompt();
    void sendPromptForModel(const QString &input, const bool &stream);

    DeepSearchState m_state = DeepSearchState::WaitingPrompt;
    QString m_userQuery;
    QString m_userFileName;
    QString m_userFileInfo;

    DataSource m_selectedSources = DataSource::Arxiv;
};

#endif // DEEPSEARCHCONVERSATION_H
