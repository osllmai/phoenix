#include "messagelist.h"
#include <algorithm>

MessageList::MessageList(QObject* parent): QAbstractListModel(parent) {}

int MessageList::count() const {
    return m_messages.count();
}

int MessageList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_messages.count();
}

QVariant MessageList::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_messages.count())
        return QVariant();

    Message* message = m_messages[index.row()];

    switch (role) {
    case IdRole:
        return message->id();
    case TextRole:
        return message->text();
    case DateRole:
        return dateCalculation(message->date());
    case IconRole:
        return message->icon();
    case IsPromptRole:
        return message->isPrompt();
    case LikeRole:
        return message->like();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> MessageList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TextRole] = "text";
    roles[DateRole] = "date";
    roles[IconRole] = "icon";
    roles[IsPromptRole] = "isPrompt";
    roles[LikeRole] = "like";
    return roles;
}

bool MessageList::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_messages.count())
        return false;

    Message* message = m_messages[index.row()];
    bool somethingChanged = false;

    switch (role) {
    case TextRole:
        if (message->text() != value.toString()) {
            message->setText(value.toString());
            somethingChanged = true;
        }
        break;
    case LikeRole:
        if (message->like() != value.toInt()) {
            message->setLike(value.toInt());
            somethingChanged = true;
        }
        break;
    }

    if (somethingChanged) {
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

void MessageList::addMessage(const int id, const QString &text, QDateTime date, const QString &icon, const bool isPrompt, const int like) {
    beginInsertRows(QModelIndex(), m_messages.size(), m_messages.size());
    Message* message = new Message(id, text, date, icon, isPrompt, like, this);
    m_messages.append(message);
    endInsertRows();
    emit countChanged();
    emit requestAddMessage(id, text, date, icon, isPrompt, like);
}

Message* MessageList::findMessageById(const int id) {
    auto it = std::find_if(m_messages.begin(), m_messages.end(), [id](Message* message) {
        return message->id() == id;
    });
    return (it != m_messages.end()) ? *it : nullptr;
}

QVariant MessageList::dateCalculation(const QDateTime date)const{
    QDateTime now = QDateTime::currentDateTime();
    if(date.daysTo(now) < 1 && date.toString("dd")==now.toString("dd"))
        return date.toString("hh:mm") + " Today";
    if(date.daysTo(now) < 7)
        return date.toString("hh:mm") + " " + date.toString("dddd");
    if(date.toString("yyyy") == now.toString("yyyy"))
        return date.toString("hh:mm") + " " + date.toString("MMMM dd");
    else
        return date.toString("hh:mm") + " " + date.toString("MM/dd/yyyy");
}

void MessageList::updateLastMessage(const QString &newText) {
    if (m_messages.isEmpty()) {
        return; // No messages to update
    }

    Message* lastMessage = m_messages.last(); // Get the last message
    if (!lastMessage) {
        return;
    }

    lastMessage->setText(lastMessage->text() + newText); // Update the text
    QModelIndex lastIndex = index(m_messages.size() - 1);
    emit dataChanged(lastIndex, lastIndex, {TextRole});
}


QVariantMap MessageList::lastMessageInfo() const {
    QVariantMap result;
    if (m_messages.isEmpty()) {
        return result; // Return empty if there are no messages
    }

    Message* lastMessage = m_messages.last();
    if (!lastMessage) {
        return result;
    }

    result["id"] = lastMessage->id();
    result["text"] = lastMessage->text();
    return result;
}
