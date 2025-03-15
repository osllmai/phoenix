#ifndef MESSAGE_H
#define MESSAGE_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

class Message : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged FINAL)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged FINAL)
    Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY iconChanged FINAL)
    Q_PROPERTY(bool isPrompt READ isPrompt WRITE setIsPrompt NOTIFY isPromptChanged FINAL)

public:
    explicit Message(QObject* parent = nullptr) : QObject(parent) {}
    explicit Message(const int &id, const QString &text, const QDateTime date, const QString &icon, bool isPrompt, QObject *parent = nullptr );

    int id() const;
    void setId(int newId);

    QString text() const;
    void setText(const QString &newText);

    QDateTime date() const;
    void setDate(const QDateTime &newDate);

    QString icon() const;
    void setIcon(const QString &newIcon);

    bool isPrompt() const;
    void setIsPrompt(bool newIsPrompt);

signals:
    void idChanged();
    void textChanged();
    void dateChanged();
    void iconChanged();
    void isPromptChanged();

private:
    int m_id;
    QString m_text;
    QDateTime m_date;
    QString m_icon;
    bool m_isPrompt;
};

#endif // MESSAGE_H
