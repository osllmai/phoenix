#ifndef CHATITEM_H
#define CHATITEM_H

#include <QObject>

class ChatItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged )
    Q_PROPERTY(QString prompt READ prompt WRITE setPrompt NOTIFY promptChanged )
    Q_PROPERTY(QString response READ response WRITE setResponse NOTIFY responseChanged )

public:
    explicit ChatItem(const int &id, const QString &prompt, QObject *parent = nullptr);

    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
    int id() const;
    QString prompt() const;
    QString response() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Write Property *----------------------------------------------------------------------------------------*//
    void setId( int id);
    void setPrompt( QString prompt);
    void setResponse( QString tokenResponse);
    //*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

signals:
    void idChanged(int id);
    void promptChanged(QString prompt);
    void responseChanged(QString tokenResponse);

private:
    int m_id;
    QString m_prompt;
    QString m_response;

};

#endif // CHATITEM_H
