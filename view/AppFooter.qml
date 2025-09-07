import QtQuick
import './component_library/style' as Style
import './component_library/button'
import './footer'

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
        anchors.left: parent.left; anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        // DownloadProgressComboBox{
        //     id: downloading
        //     visible: (offlineModelList.numberDownload > 0)?true:false
        // }
    }
    Row{
        anchors.right: parent.right; anchors.rightMargin: 5
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

        MyIcon {
            id: twitterIcon
            myIcon: "qrc:/media/icon/twitter.svg"
            myTextToolTip: "Twitter"
            myWidthToolTip: 60
            toolTipInCenter: true
            iconType: Style.RoleEnum.IconType.Primary
            onClicked: {
                Qt.openUrlExternally("https://x.com/osllmai")
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
            id: linkedinIcon
            myIcon: "qrc:/media/icon/linkedin.svg"
            myTextToolTip: "Linkedin"
            myWidthToolTip: 60
            toolTipInCenter: true
            iconType: Style.RoleEnum.IconType.Primary
            onClicked: {
                Qt.openUrlExternally("https://www.linkedin.com/company/osllmai/")
            }
        }
    }
}
