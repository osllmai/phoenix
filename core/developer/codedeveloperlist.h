#ifndef CODEDEVELOPERLIST_H
#define CODEDEVELOPERLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>
#include "./code/programlanguage.h"
#include "./code/codegenerator.h"
#include "./code/code_generator/curlcodegenerator.h"
#include "./code/code_generator/javascriptfetchcodegenerator.h"
#include "./code/code_generator/nodejsaxioscodegenerator.h"
#include "./code/code_generator/pythonrequestscodegenerator.h"

class CodeDeveloperList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(ProgramLanguage *currentProgramLanguage READ getCurrentProgramLanguage WRITE setCurrentProgramLanguage NOTIFY currentProgramLanguageChanged FINAL)

public:
    static CodeDeveloperList* instance(QObject* parent );

    enum CodeDeveloperRoles {
        IDRole = Qt::UserRole + 1,
        NameRole
    };

    Q_INVOKABLE void setCurrentLanguage(int id);

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    ProgramLanguage *getCurrentProgramLanguage() const;
    void setCurrentProgramLanguage(ProgramLanguage *newCurrentProgramLanguage);

signals:
    void countChanged();
    void currentProgramLanguageChanged();

private:
    explicit CodeDeveloperList(QObject* parent);
    static CodeDeveloperList* m_instance;

    ProgramLanguage *m_currentProgramLanguage;

    QList<ProgramLanguage*> m_programLanguags;
};

#endif // CODEDEVELOPERLIST_H
