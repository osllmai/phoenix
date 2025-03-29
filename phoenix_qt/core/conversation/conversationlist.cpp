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
    case CurrentResponseRole:
        return conversation->currentResponse();
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

bool ConversationList::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_conversations.count())
        return false;

    Conversation* conversation = m_conversations[index.row()];
    bool somethingChanged = false;

    switch (role) {
    case TitleRole:
        if (conversation->title() != value.toString()) {
            conversation->setTitle(value.toString());
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

void ConversationList::addRequest(const QString &firstPrompt){
    QStringList words = firstPrompt.split(QRegularExpression("\\s+"), Qt::SkipEmptyParts);

    QStringList selectedWords;
    for (const QString &word : words) {
        if (word.length() < 20) {
            selectedWords.append(word);
        }
        if (selectedWords.size() == 3) break;
    }

    QString title = selectedWords.join(" ");

    emit requestInsertConversation(title, firstPrompt, QDateTime::currentDateTime(), m_modelIcon, false, true,
                    m_modelPromptTemplate, m_modelSystemPrompt, 0.7, 40, 0.4,0.0,1.18,128,4096,64,2048,80, true);
}

void ConversationList::deleteRequest(const int id){
    Conversation* conversation = findConversationById(id);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);

    beginRemoveRows(QModelIndex(), index, index);
    m_conversations.removeAll(conversation);
    endRemoveRows();

    emit requestDeleteConversation(conversation->id());
    delete conversation;
}

void ConversationList::pinnedRequest(const int id, const bool isPinned){
    Conversation* conversation = findConversationById(id);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);

    conversation->setIsPinned(isPinned);//update instance
    emit requestUpdateIsPinnedConversation(conversation->id(), isPinned);//update database

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {PinnedRole});
}

void ConversationList::editTitleRequest(const int id, const QString &title){
    Conversation* conversation = findConversationById(id);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);

    conversation->setTitle(title);//update instance
    emit requestUpdateTitleConversation(conversation->id(), title);//update database

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {TitleRole});
}

void ConversationList::setModelRequest(const int id, const QString &text,  const QString &icon, const QString &promptTemplate, const QString &systemPrompt){
    setModelId(id);
    setModelText(text);
    setModelIcon(icon);
    setModelPromptTemplate(promptTemplate);
    setModelSystemPrompt(systemPrompt);
    setModelSelect(true);
    if(!m_isEmptyConversation){
        m_currentConversation->modelSettings()->setPromptTemplate(m_modelPromptTemplate);
        m_currentConversation->modelSettings()->setSystemPrompt(m_modelSystemPrompt);
    }
}

void ConversationList::addConversation(const int id, const QString &title, const QString &description, const QDateTime date, const QString &icon,
                                       const bool isPinned, const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                                       const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                       const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                       const int &contextLength, const int &numberOfGPULayers, const bool selectConversation) {
    const int index = m_conversations.size();
    beginInsertRows(QModelIndex(), index, index);
    Conversation* conversation = new Conversation(id, title, description, icon, date, isPinned,
                                                  stream, promptTemplate, systemPrompt,
                                                  temperature, topK, topP, minP, repeatPenalty,
                                                  promptBatchSize, maxTokens, repeatPenaltyTokens,
                                                  contextLength, numberOfGPULayers, this);

    m_conversations.append(conversation);
    connect(conversation, &Conversation::requestReadMessages, this, &ConversationList::readMessages, Qt::QueuedConnection);
    connect(conversation, &Conversation::requestInsertMessage, this, &ConversationList::insertMessage, Qt::QueuedConnection);
    connect(conversation, &Conversation::requestUpdateDateConversation, this, &ConversationList::updateDateConversation, Qt::QueuedConnection);
    connect(conversation, &Conversation::requestUpdateModelSettingsConversation, this, &ConversationList::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(conversation, &Conversation::requestUpadateCurrentResponse, this, &ConversationList::upadateCurrentResponse, Qt::QueuedConnection);
    endInsertRows();
    emit countChanged();

    if(selectConversation){
        setPreviousConversation(m_currentConversation);
        setCurrentConversation(conversation);
        m_currentConversation->prompt(description, m_modelId);
        setIsEmptyConversation(false);
    }
}

void ConversationList::addMessage(const int idConversation, const int id, const QString &text, QDateTime date, const QString &icon, bool isPrompt){
    Conversation* conversation = findConversationById(idConversation);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);
    conversation->addMessage(id, text, date, icon, isPrompt);
    conversation->setDate(date);
    conversation->setDescription(text);
    conversation->setIcon(icon);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DescriptionRole, IconRole, DateRole});
}

void ConversationList::selectCurrentConversationRequest(const int id){
    setPreviousConversation(m_currentConversation);
    setCurrentConversation(findConversationById(id));
    if(m_currentConversation->messageList()->count()<1)
        m_currentConversation->readMessages();
    setIsEmptyConversation(false);
    if(m_modelSelect){
        m_currentConversation->modelSettings()->setPromptTemplate(m_modelPromptTemplate);
        m_currentConversation->modelSettings()->setSystemPrompt(m_modelSystemPrompt);
    }
}

void ConversationList::readMessages(const int idConversation){
    emit requestReadMessages(idConversation);
}

void ConversationList::insertMessage(const int idConversation, const QString &text, const QString &icon, bool isPrompt){
    emit requestInsertMessage(idConversation, text, icon, isPrompt);
}

void ConversationList::updateDateConversation(const int id, const QString &description, const QString &icon){
    emit requestUpdateDateConversation(id, description, icon);
}

void ConversationList::updateModelSettingsConversation(const int id, const bool &stream,
                                     const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                     const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                     const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                     const int &contextLength, const int &numberOfGPULayers)
{
    emit requestUpdateModelSettingsConversation(id, stream, promptTemplate, systemPrompt, temperature,
                                                topK, topP, minP, repeatPenalty, promptBatchSize, maxTokens, repeatPenaltyTokens,
                                                contextLength, numberOfGPULayers);
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

    // qInfo()<<daysDiff<<"  "<<date<<"    "<<now;
    if (daysDiff < 7 && date.date().year() == now.date().year())
        return date.toString("dddd");

    if (date.date().year() == now.date().year())
        return date.toString("MMMM dd");

    return date.toString("MM/dd/yyyy");
}

void ConversationList::upadateCurrentResponse(const int idConversation){
    Conversation* conversation = findConversationById(idConversation);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {CurrentResponseRole});
}

int ConversationList::modelId() const{return m_modelId;}
void ConversationList::setModelId(int newModelId){
    if (m_modelId == newModelId)
        return;
    m_modelId = newModelId;
    emit modelIdChanged();
}

QString ConversationList::modelText() const{return m_modelText;}
void ConversationList::setModelText(const QString &newModelText){
    if (m_modelText == newModelText)
        return;
    m_modelText = newModelText;
    emit modelTextChanged();
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
