import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

import '../../../style' as Style
import '../../../button'

Item {
    id: root
    height: 30; width: parent.width

    property string myText
    property int myValue
    signal sendValue(int value)

    property bool needCopy: false

    Row{
        id: textEditor
        anchors.left: parent.left
        anchors.leftMargin: /*10*/0
        height: parent.height
        width: parent.width - 5
        TextArea {
            id: textId
            text: root.myText
            readOnly: true
            width: parent.width - valueSliderBoxId.width - (root.needCopy? copyId.width: 0)
            color: Style.Colors.textTitle
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 10
        }
        MyCopyButton{
            id: copyId
            visible: root.needCopy
            myText: textId
            anchors.verticalCenter: parent.verticalCenter
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
                onEditingFinished: {
                    valueSliderBoxId.layer.enabled= false
                }
                onPressed: {
                    valueSliderBoxId.layer.enabled= true
                }
            }
            layer.enabled: false
            layer.effect: Glow {
                 samples: 40
                 color:  Style.Colors.boxBorder
                 spread: 0.1
                 transparentBorder: true
             }
        }
    }
}
