#pragma once

#include <QQuickItem>

class Block;
class RelationHandle : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(HandleType type READ type WRITE setType NOTIFY typeChanged FINAL)
    Q_PROPERTY(HandleState state READ state WRITE setState NOTIFY stateChanged FINAL)

public:
    enum class HandleType { None, Input, Output };
    Q_ENUM(HandleType)

    enum class HandleState {
        UnConnected,
        Connectig,
        Connected
    };
    Q_ENUM(HandleState)

    RelationHandle(QQuickItem *parent = nullptr);
    void componentComplete() override;

    HandleType type() const;
    void setType(HandleType newType);

    Block *parentBlock() const;
    void setParentBlock(Block *newParentBlock);

    HandleState state() const;
    void setState(HandleState newState);

Q_SIGNALS:
    void typeChanged();

    void stateChanged();

protected:
    void mousePressEvent(QMouseEvent *event);

private:
    HandleType m_type;
    Block *_parentBlock;
    HandleState m_state{HandleState::UnConnected};
};
