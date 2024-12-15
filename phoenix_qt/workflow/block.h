#pragma once

#include <QMouseEvent>
#include <QQuickItem>
#include <QUuid>
#include "relationhandle.h"

class Block : public QQuickItem {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QUuid uuid READ uuid WRITE setUuid NOTIFY uuidChanged FINAL)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged FINAL)
    Q_PROPERTY(QQuickItem* background READ background WRITE setBackground NOTIFY backgroundChanged FINAL)
    Q_PROPERTY(QQuickItem* header READ header WRITE setHeader NOTIFY headerChanged FINAL)
    Q_PROPERTY(QQuickItem* footer READ footer WRITE setFooter NOTIFY footerChanged FINAL)
    Q_PROPERTY(QQuickItem* contentItem READ contentItem WRITE setContentItem NOTIFY contentItemChanged FINAL)
    Q_PROPERTY(int padding READ padding WRITE setPadding NOTIFY paddingChanged FINAL)
    // Q_CLASSINFO("DefaultProperty", "contentItem")

public:
    Block(QQuickItem *parent = nullptr);
    void componentComplete() override;

    QList<RelationHandle *> handles(RelationHandle::HandleType type);

    QQuickItem *header() const;
    void setHeader(QQuickItem *newHeader);

    QQuickItem *footer() const;
    void setFooter(QQuickItem *newFooter);

    QQuickItem *contentItem() const;
    void setContentItem(QQuickItem *newContentItem);

    QQuickItem *background() const;
    void setBackground(QQuickItem *newBackground);

    int padding() const;
    void setPadding(int newPadding);

    QString title() const;
    void setTitle(const QString &newTitle);

    QUuid uuid() const;
    void setUuid(const QUuid &newUuid);

protected:
    void mousePressEvent(QMouseEvent *event) override;
    void geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) override;

Q_SIGNALS:
    void moving();
    void headerChanged();
    void footerChanged();
    void contentItemChanged();

    void backgroundChanged();

    void paddingChanged();

    void titleChanged();

    void uuidChanged();

private:
    void updateImplicitHeight();

    bool m_dragging;
    QPointF m_lastMousePosition;
    QQuickItem *m_header{nullptr};
    QQuickItem *m_footer{nullptr};
    QQuickItem *m_contentItem{nullptr};
    QQuickItem *m_background{nullptr};
    int m_padding{10};

    QString m_title;
    QUuid m_uuid;
};
