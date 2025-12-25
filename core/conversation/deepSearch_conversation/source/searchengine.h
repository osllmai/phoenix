#ifndef SEARCHENGINE_H
#define SEARCHENGINE_H

#include <QObject>

class SearchEngine
{
public:
    SearchEngine();

    enum class SearchEngineState {
        WaitingSearch,

        ClassifySearch,

        SearchInSources,

        DownloadPdfs,
        SelectesResult,

        RAGPreparation,
        SendForTextModel,

        Finished
    };

    enum class SearchClassify {

    };

private:
    QString m_userQuery;
    QString m_userSummery;
    QString m_searchKeywords;

};

#endif // SEARCHENGINE_H
