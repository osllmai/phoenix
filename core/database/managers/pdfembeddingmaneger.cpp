#include "pdfembeddingmaneger.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>

// ---------------------- Constructor ----------------------
PdfEmbeddingManeger::PdfEmbeddingManeger(QSqlDatabase db, QObject* parent)
    : QObject{parent}, m_db(db)
{
    if (m_db.isOpen()) {
        QSqlQuery query(m_db);
        QStringList tables = m_db.tables();

        if (!tables.contains("pdf_embedding", Qt::CaseInsensitive)) {
            query.exec(PdfEmbedding_SQL);
        }
    } else {
        qDebug() << "Failed to open PDFEmbeddingManager:" << m_db.lastError().text();
    }
}

PdfEmbeddingManeger::~PdfEmbeddingManeger() {}


// ---------------------- SQL ----------------------
const QString PdfEmbeddingManeger::PdfEmbedding_SQL = QLatin1String(R"(
    CREATE TABLE IF NOT EXISTS pdf_embedding(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pdf_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        text_embedding TEXT NOT NULL,
        FOREIGN KEY(pdf_id)
        REFERENCES pdf(id)
        ON DELETE CASCADE
    )
)");

const QString PdfEmbeddingManeger::INSERT_PdfEmbedding_SQL = QLatin1String(R"(
    INSERT INTO pdf_embedding(pdf_id, text, text_embedding) VALUES (?, ?, ?)
)");

const QString PdfEmbeddingManeger::READ_PdfEmbedding_BY_PDF_LIST_SQL = QLatin1String(R"(
    SELECT pdf_id, text, text_embedding
    FROM pdf_embedding
    WHERE pdf_id IN (%1)
)");


// ---------------------- Insert ----------------------
void PdfEmbeddingManeger::insertPdfEmbedding(const int pdf_id, const QString &text, const QString &text_embedding){
    QSqlQuery query(m_db);

    if (!query.prepare(INSERT_PdfEmbedding_SQL))
        return;

    query.addBindValue(pdf_id);
    query.addBindValue(text);
    query.addBindValue(text_embedding);

    if (!query.exec())
        qDebug() << "Insert error:" << query.lastError().text();
}


// ---------------------- Utility: Cosine Similarity ----------------------
double PdfEmbeddingManeger::cosine(const QVector<double>& a, const QVector<double>& b) {
    double dot = 0.0, na = 0.0, nb = 0.0;
    for (int i = 0; i < a.size(); i++) {
        dot += a[i] * b[i];
        na += a[i] * a[i];
        nb += b[i] * b[i];
    }
    return dot / (std::sqrt(na) * std::sqrt(nb));
}


// ---------------------- Utility: Parse Embedding from JSON text ----------------------
QVector<double> PdfEmbeddingManeger::parseEmbedding(const QString& jsonArray) {
    QVector<double> result;
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(jsonArray.toUtf8(), &err);

    if (err.error != QJsonParseError::NoError || !doc.isArray()) {
        qDebug() << "JSON parse error in embedding:" << err.errorString();
        return result;
    }

    for (const auto& item : doc.array()) {
        result.append(item.toDouble());
    }

    return result;
}


// ---------------------- Main: Get Top Matches ----------------------
QVector<QString> PdfEmbeddingManeger::topMatches(
        const QVector<double>& targetEmbedding,
        const QList<int>& pdfIds,
        int topK
    ) {
    QVector<QString> topTexts;
    if (pdfIds.isEmpty()) return topTexts;

    QString idList;
    for (int i = 0; i < pdfIds.size(); i++) {
        idList += QString::number(pdfIds[i]);
        if (i < pdfIds.size() - 1) idList += ",";
    }

    QString sql = READ_PdfEmbedding_BY_PDF_LIST_SQL.arg(idList);
    QSqlQuery query(m_db);

    if (!query.exec(sql)) {
        qDebug() << "Query error:" << query.lastError().text();
        return topTexts;
    }

    QVector<QPair<double, QString>> scored;

    while (query.next()) {
        QString text = query.value(1).toString();
        QString embeddingStr = query.value(2).toString();

        QVector<double> embedding = parseEmbedding(embeddingStr);
        if (embedding.isEmpty() || embedding.size() != targetEmbedding.size())
            continue;

        double similarity = cosine(targetEmbedding, embedding);
        scored.append({similarity, text});
    }

    std::sort(scored.begin(), scored.end(),
              [](auto &a, auto &b){ return a.first > b.first; });

    for (int i = 0; i < qMin(topK, scored.size()); i++) {
        topTexts.append(scored[i].second);
    }

    return topTexts;
}
