import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style
import '../../component_library/button'

Item {
    id: root
    height: 60; width: parent.width

    property var model
    property string displayText
    property string myTextName: ""
    property string myTextToolTip: ""
    signal activated()

    Row{
        anchors.fill: parent
        Row{
            id: informationSliderId
            width: 100
            height: parent.height
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
            width: root.width - informationSliderId.width
            model: root.model
            displayText: root.displayText
            onActivated: { root.activated() }
        }
    }
}
