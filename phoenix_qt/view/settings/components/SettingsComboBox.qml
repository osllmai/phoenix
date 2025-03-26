import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style
import '../../component_library/button'

Item {
    id: root
    height: 60; width: parent.width

    property var model

    Row{
        anchors.fill: parent
        Row{
            id: informationSliderId
            height: 22
            width: 60
            anchors.left: parent.left
            anchors.leftMargin: 5
            Label {
                id:textId
                text: root.myTextName
                color: Style.Colors.textTitle
                font.pointSize: 10
            }

            MyIcon{
                id: aboutIcon
                width: 28; height: 28
                myIcon: aboutIcon.hovered? "qrc:/media/icon/aboutFill.svg": "qrc:/media/icon/about.svg"
                myTextToolTip: root.myTextToolTip
                anchors.verticalCenter: textId.verticalCenter
            }
        }

        MyComboBox{
            id: settingsSliderBox
            width: parent.width - informationSliderId.width
            height: 30
            model: root.model
        }
    }
}
