import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Phoenix

Block {
    id: block

    property string descript
    property alias icon: blockHeader.icon
    padding: 20

    header: BlockHeader {
        id: blockHeader
        title: block.title
        descript: block.descript
    }

    background: BlockBackground {  }


    SimpleRelationHandle {
        type: RelationHandle.Output

        anchors {
            right: parent.right
            rightMargin: -15
            top: parent.top
            topMargin: 25
        }
    }

    SimpleRelationHandle {
        type: RelationHandle.Input
        anchors {
            left: parent.left
            leftMargin: -15
            top: parent.top
            topMargin: 25
        }
    }
}
