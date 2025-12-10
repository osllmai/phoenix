#ifndef RESPONSELIST_H
#define RESPONSELIST_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>

class ResponseList: public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
public:
    explicit ResponseList(QObject* parent = nullptr);

    enum MessageRoles {
        IdRole = Qt::UserRole + 1,
        TextRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void addToken(const QString &text);

signals:
    void countChanged();

private:
    QList<QString> m_tokens;
};

#endif // RESPONSELIST_H
