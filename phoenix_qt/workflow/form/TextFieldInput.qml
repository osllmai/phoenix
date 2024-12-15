import QtQuick
import QtQuick.Controls
import Phoenix

Item {
    property alias title: titleLabel.text

    height: titleLabel.height + field.height

    Label {
        id: titleLabel
        anchors{
            right: parent.right
            left: parent.left
        }
    }

    TextField {
        id: field
        anchors{
            right: parent.right
            left: parent.left
            top: titleLabel.bottom
        }
    }

    SimpleRelationHandle {
        type: RelationHandle.Output

        anchors {
            right: parent.right
            rightMargin: -15
            verticalCenter: parent.verticalCenter
        }
    }

    SimpleRelationHandle {
        type: RelationHandle.Input
        anchors {
            left: parent.left
            leftMargin: -15
            verticalCenter: parent.verticalCenter
        }
    }
}
