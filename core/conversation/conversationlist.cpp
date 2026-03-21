#include "conversationlist.h"
#include <algorithm>

ConversationList* ConversationList::m_instance = nullptr;

ConversationList* ConversationList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new ConversationList(parent);
    }
    return m_instance;
}

ConversationList::ConversationList(QObject* parent):
    QAbstractListModel(parent),
    m_currentConversation(nullptr),
    m_previousConversation(nullptr),
    m_isEmptyConversation(true),
    m_modelSelect(false)
{}

void ConversationList::readDB(){
    emit requestReadConversation();
}

int ConversationList::count() const { return m_conversations.count(); }

int ConversationList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_conversations.count();
}

QVariant ConversationList::data(const QModelIndex &index, int role = Qt::DisplayRole) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_conversations.count())
        return QVariant();

    Conversation* conversation = m_conversations[index.row()];
    if (!conversation) {
        return QVariant();
    }

    switch (role) {
    case IdRole:
        return conversation->id();
    case TitleRole:
        return conversation->title();
    case DescriptionRole:
        return conversation->description();
    case QDateTimeRole:
        return conversation->date();
    case DateRole:
        return dateCalculation(conversation->date());
    case PinnedRole:
        return conversation->isPinned();
    case IconRole:
        return conversation->icon();
    case ModelSettingsRole:
        return QVariant::fromValue(conversation->modelSettings());
    case IsLoadModelRole:
        return conversation->isLoadModel();
    case loadModelInProgressRole:
        return conversation->loadModelInProgress();
    case ResponseInProgressRole:
        return conversation->responseInProgress();
    case MessageListRole:
        return QVariant::fromValue(conversation->messageList());
    case ConversationObjectRole:
        return QVariant::fromValue(conversation);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ConversationList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TitleRole] = "title";
    roles[PinnedRole] = "pinned";
    roles[IconRole] = "icon";
    roles[DescriptionRole] = "description";
    roles[DateRole] = "date";
    roles[ModelSettingsRole] = "modelSettings";
    roles[IsLoadModelRole] = "isLoadModel";
    roles[loadModelInProgressRole] = "loadModelInProgress";
    roles[ResponseInProgressRole] = "responseInProgress";
    roles[MessageListRole] = "messageList";
    roles[ConversationObjectRole] = "conversationObject";
    return roles;
}

Conversation* ConversationList::findConversationById(const int id) {
    auto it = std::find_if(m_conversations.begin(), m_conversations.end(), [id](Conversation* conversation) {
        return conversation->id() == id;
    });
    return (it != m_conversations.end()) ? *it : nullptr;
}

QVariant ConversationList::dateCalculation(const QDateTime date) const {
    QDateTime now = QDateTime::currentDateTime();
    if (date.date() == now.date())
        return date.toString("hh:mm") + " Today";

    int daysDiff = date.daysTo(now);

    if (daysDiff < 7 && date.date().year() == now.date().year())
        return date.toString("dddd");

    if (date.date().year() == now.date().year())
        return date.toString("MMMM dd");

    return date.toString("MM/dd/yyyy");
}

int ConversationList::modelId() const{return m_modelId;}
void ConversationList::setModelId(int newModelId){
    if (m_modelId == newModelId)
        return;
    m_modelId = newModelId;
    emit modelIdChanged();
}

QString ConversationList::modelName() const{return m_modelName;}
void ConversationList::setModelName(const QString &newModelName){
    if (m_modelName == newModelName)
        return;
    m_modelName = newModelName;
    emit modelNameChanged();
}

QString ConversationList::modelIcon() const{return m_modelIcon;}
void ConversationList::setModelIcon(const QString &newModelIcon){
    if (m_modelIcon == newModelIcon)
        return;
    m_modelIcon = newModelIcon;
    emit modelIconChanged();
}

QString ConversationList::modelSystemPrompt() const{ return m_modelSystemPrompt; }
void ConversationList::setModelSystemPrompt(const QString &newModelSystemPrompt){
    if (m_modelSystemPrompt == newModelSystemPrompt)
        return;
    m_modelSystemPrompt = newModelSystemPrompt;
    emit modelSystemPromptChanged();
}

QString ConversationList::modelPromptTemplate() const{ return m_modelPromptTemplate; }
void ConversationList::setModelPromptTemplate(const QString &newModelPromptTemplate){
    if (m_modelPromptTemplate == newModelPromptTemplate)
        return;
    m_modelPromptTemplate = newModelPromptTemplate;
    emit modelPromptTemplateChanged();
}

bool ConversationList::modelSelect() const{return m_modelSelect;}
void ConversationList::setModelSelect(bool newModelSelect){
    if (m_modelSelect == newModelSelect)
        return;
    m_modelSelect = newModelSelect;
    emit modelSelectChanged();
}

bool ConversationList::isEmptyConversation() const{ return m_isEmptyConversation;}
void ConversationList::setIsEmptyConversation(bool newIsEmptyConversation){
    if (m_isEmptyConversation == newIsEmptyConversation)
        return;

    m_isEmptyConversation = newIsEmptyConversation;
    if(m_isEmptyConversation){
        if((m_currentConversation != nullptr) && m_currentConversation->isLoadModel())
            setPreviousConversation(m_currentConversation);
        setCurrentConversation(nullptr);
    }

    emit isEmptyConversationChanged();
}

Conversation *ConversationList::previousConversation() {return m_previousConversation;}
void ConversationList::setPreviousConversation(Conversation *newPreviousConversation){
    if (m_previousConversation == newPreviousConversation)
        return;
    m_previousConversation = newPreviousConversation;
    emit previousConversationChanged();
}

Conversation *ConversationList::currentConversation() { return m_currentConversation;}
void ConversationList::setCurrentConversation(Conversation *newCurrentConversation){
    if (m_currentConversation == newCurrentConversation)
        return;
    m_currentConversation = newCurrentConversation;
    emit currentConversationChanged();
}
