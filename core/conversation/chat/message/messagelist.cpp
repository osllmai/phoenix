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
    case FileNameRole:
        return message->fileName();
    case DateRole:
        return dateCalculation(message->date());
    case IconRole:
        return message->icon();
    case IsPromptRole:
        return message->isPrompt();
    case IsDeepSearchRole:
        return message->isDeepSearch();
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
    roles[FileNameRole] = "fileName";
    roles[DateRole] = "date";
    roles[IconRole] = "icon";
    roles[IsPromptRole] = "isPrompt";
    roles[IsDeepSearchRole] = "isDeepSearch";
    roles[LikeRole] = "like";
    return roles;
}

bool MessageList::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_messages.count())
        return false;

    Message* message = m_messages[index.row()];
    bool changed = false;

    switch (role) {
    case TextRole:
        if (message->text() != value.toString()) {
            message->setText(value.toString());
            changed = true;
        }
        break;

    case LikeRole:
        if (message->like() != value.toInt()) {
            message->setLike(value.toInt());
            changed = true;
        }
        break;
    }

    if (changed) {
        emit dataChanged(index, index, {role});
        return true;
    }
    return false;
}

void MessageList::addMessage(
    const int id, const QString &text, const QString &fileName,
    QDateTime date, const QString &icon,
    const bool isPrompt, const bool isDeepSearch, const int like)
{
    beginInsertRows(QModelIndex(), m_messages.size(), m_messages.size());
    Message* message = new Message(id, text, fileName, date, icon, isPrompt, isDeepSearch, like, this);
    m_messages.append(message);
    endInsertRows();
    emit countChanged();
}

Message* MessageList::findMessageById(const int id) {
    auto it = std::find_if(m_messages.begin(), m_messages.end(),
                           [id](Message* msg){ return msg->id() == id; });
    return (it != m_messages.end()) ? *it : nullptr;
}

QVariant MessageList::dateCalculation(const QDateTime date) const {
    QDateTime now = QDateTime::currentDateTime();
    if (date.daysTo(now) < 1 && date.toString("dd") == now.toString("dd"))
        return date.toString("hh:mm") + " Today";
    if (date.daysTo(now) < 7)
        return date.toString("hh:mm dddd");
    if (date.toString("yyyy") == now.toString("yyyy"))
        return date.toString("hh:mm MMMM dd");
    return date.toString("hh:mm MM/dd/yyyy");
}

void MessageList::updateLastMessage(const QString &newText) {
    if (m_messages.isEmpty()) return;

    Message* last = m_messages.last();
    last->setText(last->text() + newText);
    QModelIndex idx = index(m_messages.size() - 1);
    emit dataChanged(idx, idx, {TextRole});
}

void MessageList::updateAllTextMessage() {
    if (m_messages.isEmpty()) return;

    emit dataChanged(
        createIndex(0, 0),
        createIndex(m_messages.size() - 1, 0),
        {TextRole}
        );
}

QVariantMap MessageList::lastMessageInfo() const {
    QVariantMap result;
    if (m_messages.isEmpty()) return result;

    Message* msg = m_messages.last();
    result["id"] = msg->id();
    result["text"] = msg->text();
    return result;
}

void MessageList::likeMessageRequest(const int messageId, const int like) {
    Message* message = findMessageById(messageId);
    if (!message) return;

    int idx = m_messages.indexOf(message);
    message->setLike(like);
    emit dataChanged(index(idx), index(idx), {LikeRole});
}

QString MessageList::history(int count) const {
    QStringList list;
    int size = m_messages.size();
    int start = qMax(0, size - count);

    for (int i = start; i < size; ++i) {
        Message* m = m_messages[i];
        QString role = m->isPrompt() ? "User" : "Assistant";
        list << QString("%1: %2").arg(role, m->text());
    }
    return list.join("\n");
}
