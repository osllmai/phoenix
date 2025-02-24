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
        MyIcon {
            id: downloading
            myIcon: "qrc:/media/icon/systemMonitor.svg"
            iconType: Style.RoleEnum.IconType.Primary
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
                y: downloading.y - downloadingPupup.height
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
                y: systemMonitoring.y - systemMonitorPupup.height
            }
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
