import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property alias title: titleLabel.text
    property alias descript: descriptLabel.text
    property alias icon: iconImage.source

    property int padding: 15

    implicitHeight: mainLayout.height + padding
    height: implicitHeight

    anchors{
        top: parent.top
        left: parent.left
        right: parent.right
    }

    ColumnLayout {
        id: mainLayout
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right

            topMargin: root.padding
            leftMargin: root.padding
            rightMargin: root.padding
        }

        RowLayout {
            Image {
                id: iconImage
                fillMode: Image.PreserveAspectFit
                Layout.preferredHeight: 24
                Layout.preferredWidth: 24
            }
            Label {
                id: titleLabel
                Layout.fillWidth: true
                wrapMode: Label.WordWrap
                font {
                    bold: true
                    pixelSize: 16
                }
            }
        }
        Label {
            id: descriptLabel
            Layout.fillWidth: true
            wrapMode: Label.WordWrap
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: "gray"
    }
}
