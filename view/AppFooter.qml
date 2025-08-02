import QtQuick
import './component_library/style' as Style
import './component_library/button'
import './component_footer'

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
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter

        MyProgress{
            id: downloading
            visible: offlineModelList.downloadProgress>0.0001

            myText: "Downloading"
            myValue: offlineModelList.downloadProgress
            myIcon: downloading.hovered? "qrc:/media/icon/downloadFill.svg":"qrc:/media/icon/download.svg"
            textLenght: 75
            enabled: true
            onHoveredChanged: function(){
                if(downloading.hovered){
                    downloadingPupup.open()
                }else{
                    downloadingPupup.close()
                }
            }

            Downloading{
                id: downloadingPupup
                x: downloading.x
                y: downloading.y - downloadingPupup.height - 10
            }
        }
    }
    Row{
        anchors.right: parent.right; anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        MyIcon {
            id: systemMonitoring
            myIcon: "qrc:/media/icon/systemMonitor.svg"
            iconType: Style.RoleEnum.IconType.Primary
            onHoveredChanged: function(){
                if(systemMonitoring.hovered){
                    systemMonitor.runSystemMonitor(true)
                    systemMonitorPupup.open()
                }else{
                    systemMonitor.runSystemMonitor(false)
                    systemMonitorPupup.close()
                }
            }
            SystemMonitoring{
                id: systemMonitorPupup
                x: systemMonitoring.x - 124
                y: systemMonitoring.y - systemMonitorPupup.height - 10
            }
        }
        MyIcon {
            id: githubIcon
            myIcon: "qrc:/media/icon/github.svg"
            myTextToolTip: "Github"
            myWidthToolTip: 60
            toolTipInCenter: true
            iconType: Style.RoleEnum.IconType.Primary
            onClicked: {
                Qt.openUrlExternally("https://github.com/osllmai")
            }
        }
        MyIcon {
            id: githubIcon
            myIcon: "qrc:/media/icon/github.svg"
            myTextToolTip: "Github"
            myWidthToolTip: 60
            toolTipInCenter: true
            iconType: Style.RoleEnum.IconType.Primary
            onClicked: {
                Qt.openUrlExternally("https://github.com/osllmai")
            }
        }
        MyIcon {
            id: githubIcon
            myIcon: "qrc:/media/icon/github.svg"
            myTextToolTip: "Github"
            myWidthToolTip: 60
            toolTipInCenter: true
            iconType: Style.RoleEnum.IconType.Primary
            onClicked: {
                Qt.openUrlExternally("https://github.com/osllmai")
            }
        }
        MyIcon {
            id: discordIcon
            myIcon: "qrc:/media/icon/discord.svg"
            myTextToolTip: "Discord"
            myWidthToolTip: 65
            toolTipInCenter: true
            iconType: Style.RoleEnum.IconType.Primary
            onClicked: {
                Qt.openUrlExternally("https://discord.gg/pufX5Aua2g")
            }
        }
    }
}
