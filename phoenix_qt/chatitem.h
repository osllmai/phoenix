#ifndef CHATITEM_H
#define CHATITEM_H

#include <QObject>
#include <message.h>

class ChatItem : public QObject{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged )
    Q_PROPERTY(Message *prompt READ prompt WRITE setPrompt NOTIFY promptChanged )
    Q_PROPERTY(Message *response READ response WRITE setResponse NOTIFY responseChanged )
    Q_PROPERTY(int numberOfPrompt READ numberOfPrompt NOTIFY numberOfPromptChanged )
    Q_PROPERTY(int numberOfEditPrompt READ numberOfEditPrompt NOTIFY numberOfEditPromptChanged )
    Q_PROPERTY(int numberOfResponse READ numberOfResponse NOTIFY numberOfResponseChanged)
    Q_PROPERTY(int numberOfRegenerate READ numberOfRegenerate NOTIFY numberOfRegenerateChanged )

public:
    explicit ChatItem(const int &id, Message *prompt, Message *response, int numberOfPrompt, int numberOfEditPrompt, int numberOfResponse, int numberOfRegenerate, QObject *parent);

    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
    int id() const;
    Message* prompt();
    Message* response();
    int numberOfPrompt() const;
    int numberOfEditPrompt() const;
    int numberOfResponse() const;
    int numberOfRegenerate() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Write Property *----------------------------------------------------------------------------------------*//
    void setId(const int id);
    void setPrompt(Message *prompt);
    void setResponse(Message *response);
    //*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

signals:
    void idChanged(int id);
    void promptChanged();
    void responseChanged();
    void numberOfPromptChanged();
    void numberOfEditPromptChanged();
    void numberOfResponseChanged();
    void numberOfRegenerateChanged();

private:
    int m_id;
    Message *m_prompt;
    Message *m_response;
    int m_numberOfPrompt;
    int m_numberOfEditPrompt;
    int m_numberOfResponse;
    int m_numberOfRegenerate;
};

#endif // CHATITEM_H
