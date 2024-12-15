import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Phoenix
import '..'

Block {
    title: "Node"

    property string note
    property bool isEditing: false

    BlockBackground {
        anchors.fill: parent
    }

    contentItem: Label {
        text: note

        MouseArea {
            anchors.fill: parent
            onClicked: {

                isEditing = true
            }
        }
    }
    TextArea {
        anchors.fill: parent
        visible: isEditing

        onFocusChanged: {
            if (!focus)
                isEditing = false
        }

        Keys.onReturnPressed: {
            isEditing = false
            note= text
        }
    }
}
