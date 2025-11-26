#include "pdfmanager.h"

PdfManager::PdfManager(QSqlDatabase db, QObject* parent)
    : QObject{nullptr}, m_db(db)
{
    if (m_db.isOpen()) {
        QSqlQuery query(m_db);

        QStringList tables = m_db.tables();
        if (!tables.contains("pdf", Qt::CaseInsensitive)) {
            query.exec(PDF_SQL);
        }
    } else {
        qDebug() << "Failed to open ModelManager:" << m_db.lastError().text();
    }
}

PdfManager::~PdfManager(){}

const QString PdfManager::PDF_SQL = QLatin1String(R"(
    CREATE TABLE IF NOT EXISTS pdf(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conversation_id INTEGER NOT NULL,
        file_Path TEXT NOT NULL,
        FOREIGN KEY(conversation_id)
        REFERENCES conversation(id)
        ON DELETE CASCADE
    )
)");

const QString PdfManager::INSERT_PDF_SQL = QLatin1String(R"(
    INSERT INTO pdf(conversation_id, file_Path)
    VALUES (?, ?)
)");

const QString PdfManager::READ_PDF_SQL = QLatin1String(R"(
    SELECT id, file_Path
    FROM pdf
    WHERE conversation_id=?
)");

void PdfManager::insertPdf(const int conversation_id, const QString &file_Path){
    QSqlQuery query(m_db);

    if (!query.prepare(INSERT_PDF_SQL))
        return;
    query.addBindValue(conversation_id);
    query.addBindValue(file_Path);
    if (!query.exec())
        return;

    int id = query.lastInsertId().toInt();

    emit addPdf(conversation_id, id, file_Path);
}

void PdfManager::readPdf(const int idConversation){
    QSqlQuery query(m_db);
    query.prepare(READ_PDF_SQL);

    query.addBindValue(idConversation);
    if (query.exec()){
        while(query.next()) {
            emit addPdf(
                idConversation,
                query.value(0).toInt(),
                query.value(1).toString()
            );
        }
    }
    emit finishedReadPdf();
}
