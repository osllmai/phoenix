#ifndef PDFEMBEDDINGMANEGER_H
#define PDFEMBEDDINGMANEGER_H

#include <QObject>
#include <QQmlEngine>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVector>
#include <QPair>
#include <algorithm>
#include <cmath>

class PdfEmbeddingManeger : public QObject
{
    Q_OBJECT
    QML_SINGLETON
public:
    explicit PdfEmbeddingManeger(QSqlDatabase db, QObject* parent = nullptr);
    virtual ~PdfEmbeddingManeger();

    // void readPdfEmbedding(const int idConversation);
    void insertPdfEmbedding(const int pdf_id, const QString &text, const QString &text_embedding);

    QVector<QString> topMatches(
        const QVector<double>& targetEmbedding,
        const QList<int>& pdfIds,
        int topK = 10
        );

private:
    QSqlDatabase m_db;

    static const QString PdfEmbedding_SQL;
    static const QString INSERT_PdfEmbedding_SQL;
    static const QString READ_PdfEmbedding_BY_PDF_LIST_SQL;

    double cosine(const QVector<double>& a, const QVector<double>& b);
    QVector<double> parseEmbedding(const QString& jsonArray);
};

#endif // PDFEMBEDDINGMANEGER_H
