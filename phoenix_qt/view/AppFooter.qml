import QtQuick
import './component_library/style' as Style
import './component_library/button'

Item {
    id: control
    width: parent.width; height: 30

    Rectangle{
        id:line
        width: parent.width; height: 1
        color: Style.Colors.boxBorder
        anchors.top: parent.top
    }

    Row{
        anchors.right: parent.right; anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        MyIcon {
            id: systemMonitoorIcon

            myIcon: "qrc:/media/icon/systemMonitor.svg"
            iconType: Style.RoleEnum.IconType.Primary
        }
        MyIcon {
            id: githubIcon
            myIcon: "qrc:/media/icon/github.svg"
            iconType: Style.RoleEnum.IconType.Primary
        }
        MyIcon {
            id: discordIcon
            myIcon: "qrc:/media/icon/discord.svg"
            iconType: Style.RoleEnum.IconType.Primary
        }
    }
}
