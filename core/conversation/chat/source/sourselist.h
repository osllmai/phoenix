#ifndef SOURSELIST_H
#define SOURSELIST_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>

#include "source.h"

class SourseList : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    explicit SourseList(QObject *parent = nullptr);

    enum sourceRoles {
        IdRole = Qt::UserRole + 1,
        TitelRole,
        TextRole,
        IconRole,
        LinkRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void add(int id, const QString &titel, const QString &text,
             const QString &icon, const QString &link);
    void clear();

signals:
    void countChanged();

private:
    QList<Source*> m_sources;
};

#endif // SOURSELIST_H
