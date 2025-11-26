#include "pdfembeddingmaneger.h"

PdfEmbeddingManeger::PdfEmbeddingManeger(QSqlDatabase db, QObject* parent)
    : QObject{nullptr}, m_db(db)
{

    if (m_db.isOpen()) {
        QSqlQuery query(m_db);

        QStringList tables = m_db.tables();
        if (!tables.contains("pdf_embedding", Qt::CaseInsensitive)) {
            query.exec(PdfEmbedding_SQL);
        }
    } else {
        qDebug() << "Failed to open ModelManager:" << m_db.lastError().text();
    }
}

PdfEmbeddingManeger::~PdfEmbeddingManeger(){}

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

const QString PdfEmbeddingManeger::READ_PdfEmbedding_SQL = QLatin1String(R"(
    SELECT id, text, text_embedding
    FROM pdf_embedding
    WHERE pdf_id=?
)");

void PdfEmbeddingManeger::insertPdfEmbedding(const int pdf_id, const QString &text, const QString &text_embedding){
    QSqlQuery query(m_db);

    if (!query.prepare(INSERT_PdfEmbedding_SQL))
        return;
    query.addBindValue(pdf_id);
    query.addBindValue(text);
    query.addBindValue(text_embedding);
    if (!query.exec())
        return;

    int id = query.lastInsertId().toInt();

    emit addPdfEmbedding(pdf_id, id, text, text_embedding);
}

void PdfEmbeddingManeger::readPdfEmbedding(const int pdf_id){
    QSqlQuery query(m_db);
    query.prepare(READ_PdfEmbedding_SQL);

    query.addBindValue(pdf_id);
    if (query.exec()){
        while(query.next()){
            emit addPdfEmbedding(
                pdf_id,
                query.value(0).toInt(),
                query.value(1).toString(),
                query.value(2).toString()
                );
        }
    }
    emit finishedReadPdfEmbedding();
}
