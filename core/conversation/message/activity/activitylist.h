#ifndef ACTIVITYLIST_H
#define ACTIVITYLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>

#include "activity.h"

class ActivityList: public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
public:
    explicit ActivityList(QObject* parent = nullptr);

    enum activityRoles {
        IdRole = Qt::UserRole + 1,
        TextRole,
        IconRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void add(const int id, const QString &text, const QString &icon);
    void clear();

signals:
    void countChanged();

private:
    QList<Activity*> m_activitys;
};

#endif // ACTIVITYLIST_H
