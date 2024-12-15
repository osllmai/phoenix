#pragma once

#include <block.h>

class ChatInputBlock : public Block
{
    Q_OBJECT
    QML_ELEMENT

public:
    ChatInputBlock(QQuickItem *parent = nullptr);
};
