#ifndef DEEPSEARCHCONVERSATION_H
#define DEEPSEARCHCONVERSATION_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>
#include <QThread>

#include "../../model/modelsettings.h"
#include "../chat/messagelist.h"
#include "../../model/model.h"
#include "../../model/offline/offlinemodellist.h"
#include "../../model/online/onlinemodellist.h"
#include "../../model/online/onlinecompanylist.h"
#include "../../model/online/onlinecompany.h"
#include "../../provider/provider.h"
#include "../conversation.h"
#include "./arxiv/arxivsearchworker.h"

#include <QLoggingCategory>
#include "logcategories.h"
#include "arxivarticlelist.h"

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
        WaitingPrompt,           // Waiting for initial user input

        ClassifyQuery,           // Decide: local answer or deep/external search required?

        GenerateClarificationQuestions, // Model generates clarifying questions if needed
        WaitingUserClarifications,      // Waiting for user's answers to those questions

        GenerateSearchKeywords,  // Use model to generate optimized keywords for search

        SearchInSources,         // Search in external sources (arXiv, Web, Local Docs)

        generateUserIntentSummary,
        SelectesPdfs,

        DownloadAndPdfTokenizer,       // Download relevant documents and Extract text from documents
        RAGPreparation,          // Retrieve relevant chunks for RAG context
        SendForTextModel,        // Send final constructed prompt to LLM

        Finished                 // Response is done & reset conversation state
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
    void generateClarificationQuestions();
    void generateUserIntentSummary();
    void generateSearchKeywords();
    void onSearchResultsReady(QList<QVariantMap> results);
    void startSearchInSources();
    void finalPrompt();
    void sendPromptForModel(const QString &input, const bool &stream);

    DeepSearchState m_state = DeepSearchState::WaitingPrompt;
    QString m_userQuery;
    QString m_userSummery;
    QString m_userFileName;
    QString m_userFileInfo;
    QString m_searchKeywords;

    DataSource m_selectedSources = DataSource::Arxiv;
    ArxivArticleList *m_arxivModel;

};

#endif // DEEPSEARCHCONVERSATION_H
