#include "block.h"

#include <QDebug>

namespace zIndexes {
constexpr int Header{2};
constexpr int Footer{2};
constexpr int ContentItem{1};
constexpr int Background{0};
} // namespace zIndexes

namespace {
inline int itemHeight(QQuickItem *item) {
    if (!item)
        return 0;
    return item->height() ? item->height() : item->implicitHeight();
}
}
Block::Block(QQuickItem *parent)
    : QQuickItem(parent)
    , m_dragging(false)
{
    setAcceptedMouseButtons(Qt::LeftButton);
    setAcceptHoverEvents(true);
    setImplicitWidth(150);
}

void Block::componentComplete() {
    QQuickItem::componentComplete();
    updateImplicitHeight();
}

QList<RelationHandle *> Block::handles(RelationHandle::HandleType type)
{
    auto list = findChildren<RelationHandle *>();
    QList<RelationHandle *> ret;
    std::copy_if(list.begin(), list.end(), std::back_inserter(ret), [&type](RelationHandle *h) {
        return h->type() == type;
    });
    return ret;
}

void Block::mousePressEvent(QMouseEvent *event)
{
    //     if (event->button() == Qt::LeftButton) {
    //         m_dragging = true;
    //         m_lastMousePosition = event->pos();
    //     }
    //     QQuickItem::mousePressEvent(event);
    //     event->accept();
    //     qDebug() << "!" << position();

    QQuickItem::mousePressEvent(event);
    event->accept();
}

void Block::geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    QQuickItem::geometryChange(newGeometry, oldGeometry);
    updateImplicitHeight();

    qreal width = newGeometry.width();
    qreal height = newGeometry.height();

    qreal headerHeight = m_header ? m_header->height() : 0;
    // ? (m_header->implicitHeight() > 0 ? m_header->implicitHeight() : 30)
    // : 0;
    qreal footerHeight = m_footer ? m_footer->height() : 0;
    // ? (m_footer->implicitHeight() > 0 ? m_footer->implicitHeight() : 30) : 0;

    // Position and size the header
    if (m_header) {
        m_header->setWidth(width);
        m_header->setHeight(headerHeight);
        m_header->setPosition(QPointF(0, 0));
    }

    // Position and size the footer
    if (m_footer) {
        m_footer->setWidth(width);
        m_footer->setHeight(footerHeight);
        m_footer->setPosition(QPointF(0, height - footerHeight));
    }

    // Position and size the contentItem
    if (m_contentItem) {
        qreal contentHeight = height - headerHeight - footerHeight;
        m_contentItem->setWidth(width - 2 * m_padding);
        m_contentItem->setHeight((contentHeight > 0 ? contentHeight : 0) - 2 * m_padding);
        m_contentItem->setPosition(QPointF(m_padding, headerHeight + m_padding));
    }

    if (m_background) {
        m_background->setSize(newGeometry.size());
    }
}

void Block::updateImplicitHeight()
{
    setImplicitHeight(itemHeight(m_header) + itemHeight(m_contentItem) + itemHeight(m_footer)
                      + 2 * m_padding);
    setHeight(implicitHeight());
    // qDebug() << "Implicit height updated for" << m_title

    //          << "H=" << implicitHeight() << "header=" << itemHeight(m_header)
    //          << "content=" << itemHeight(m_contentItem);
}

// void Block::mouseMoveEvent(QMouseEvent *event)
// {
//     if (m_dragging) {
//         QPointF delta = event->pos() - m_lastMousePosition;
//         setPosition(position() + delta);
//         qDebug() << position();
//         Q_EMIT moving();
//     }
//     QQuickItem::mouseMoveEvent(event);
// }

// void Block::mouseReleaseEvent(QMouseEvent *event)
// {
//     if (event->button() == Qt::LeftButton) {
//         m_dragging = false;
//     }
//     QQuickItem::mouseReleaseEvent(event);
// }

QQuickItem *Block::header() const
{
    return m_header;
}

void Block::setHeader(QQuickItem *newHeader)
{
    if (m_header == newHeader)
        return;
    m_header = newHeader;
    m_header->setParentItem(this);
    m_header->setZ(zIndexes::Header);
    connect(m_header, &QQuickItem::heightChanged, this, &Block::updateImplicitHeight);
    updateImplicitHeight();
    emit headerChanged();
    update();
}

QQuickItem *Block::footer() const
{
    return m_footer;
}

void Block::setFooter(QQuickItem *newFooter)
{
    if (m_footer == newFooter)
        return;
    m_footer = newFooter;
    m_footer->setParentItem(this);
    m_footer->setZ(zIndexes::Footer);
    updateImplicitHeight();
    emit footerChanged();
    update();
}

QQuickItem *Block::contentItem() const
{
    return m_contentItem;
}

void Block::setContentItem(QQuickItem *newContentItem)
{
    if (m_contentItem == newContentItem)
        return;
    m_contentItem = newContentItem;
    m_contentItem->setParentItem(this);
    m_contentItem->setZ(zIndexes::ContentItem);
    connect(m_contentItem, &QQuickItem::implicitHeightChanged, this, &Block::updateImplicitHeight);
    connect(m_contentItem, &QQuickItem::heightChanged, this, &Block::updateImplicitHeight);
    updateImplicitHeight();
    emit contentItemChanged();
    update();
}

QQuickItem *Block::background() const
{
    return m_background;
}

void Block::setBackground(QQuickItem *newBackground)
{
    if (m_background == newBackground)
        return;
    m_background = newBackground;
    m_background->setParentItem(this);
    m_background->setZ(zIndexes::Background);
    updateImplicitHeight();
    emit backgroundChanged();
    update();
}

int Block::padding() const
{
    return m_padding;
}

void Block::setPadding(int newPadding)
{
    if (m_padding == newPadding)
        return;
    m_padding = newPadding;
    emit paddingChanged();
    update();
}

QString Block::title() const
{
    return m_title;
}

void Block::setTitle(const QString &newTitle)
{
    if (m_title == newTitle)
        return;
    m_title = newTitle;
    emit titleChanged();
}

QUuid Block::uuid() const
{
    return m_uuid;
}

void Block::setUuid(const QUuid &newUuid)
{
    if (m_uuid == newUuid)
        return;
    m_uuid = newUuid;
    emit uuidChanged();
}
