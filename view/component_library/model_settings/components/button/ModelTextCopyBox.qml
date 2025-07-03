import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../../style' as Style
import '../../../button'

Item {
    id: root
    height: 30; width: parent.width

    property string myText
    property bool checkCopy: false

    Row{
        id: textEditor
        anchors.left: parent.left
        anchors.leftMargin: 0
        height: parent.height
        width: parent.width

        TextArea {
            id: textId
            text: root.myText
            color: Style.Colors.textTitle
            readOnly: true
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - copyId.width
            font.pointSize: 10
        }

        MyCopyButton{
            id: copyId
            myText: textId
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
