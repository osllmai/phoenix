import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../../style' as Style

Item {
    id: root
    height: 30; width: parent.width

    property string myText
    property int myValue
    signal sendValue(int value)

    Row{
        id: textEditor
        anchors.left: parent.left
        anchors.leftMargin: 10
        height: parent.height
        width: parent.width - 5
        Label {
            id: textId
            text: root.myText
            width: parent.width - valueSliderBoxId.width
            color: Style.Colors.textTitle
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 10
        }
        Rectangle{
            id:valueSliderBoxId
            color: Style.Colors.background
            border.color: Style.Colors.boxBorder
            width: 50; height: 30
            anchors.verticalCenter: parent.verticalCenter
            radius: 8

            TextField {
                id: valueSlider2Id
                text: myValue.toFixed(0)
                color: Style.Colors.textTitle
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 8
                inputMethodHints: Qt.ImhDigitsOnly
                background: null

                validator: IntValidator{
                    bottom: 1
                    top: 65535
                }
                onTextChanged: sendValue(text)
            }
        }
    }
}
