import QtQuick
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import './component_library/style' as Style
import './component_library/button'

T.Button {
    id: titleBar
    width: parent.width
    height: 40

    onPressed: mouse => window.startSystemMove()
    onDoubleClicked: mouse => maximizeSquareButtonId.clicked()

    background: null
     contentItem: Rectangle {
         id: backgroundId
         anchors.fill: parent
         border.width: 1
         border.color: Style.Colors.boxBorder
         color: Style.Colors.boxHover
         Row{
             id: aboutId
             anchors.left: parent.left
             anchors.verticalCenter: parent.verticalCenter
             MyIcon {
                 id: logoId
                 myIcon:  "qrc:/media/image_company/Phoenix.svg"
                 iconType: Style.RoleEnum.IconType.Primary
                 enabled: false
                 width:30; height:30
             }
             Label {
                 id: phoenixTitleId
                 text: "Phoenix v0.1.2"
                 color: Style.Colors.textTitle
                 anchors.verticalCenter: logoId.verticalCenter
                 font.pixelSize: 14
                 font.styleName: "Bold"
             }
             MyIcon {
                 id: maximizeHSquareButtonId
                 myIcon:  "qrc:/media/icon/maximizeH.svg"
                 iconType: Style.RoleEnum.IconType.Primary
                 anchors.verticalCenter: phoenixTitleId.verticalCenter
                 width:23; height:23
                 Connections{
                     target: maximizeHSquareButtonId
                     function onClicked(){

                        if ((window.width === 400 ) && (window.height === Screen.height) &&
                                (window.x === Screen.width - 400) && (window.y === 0)){
                               window.width = window.prevW
                               window.height = window.prevH
                               window.x = window.prevX
                               window.y = window.prevY
                        }else{
                                if (window.visibility === Window.Maximized)
                                    window.showNormal()

                               window.prevX = window.x
                               window.prevY = window.y
                               window.prevW = window.width
                               window.prevH = window.height

                               window.width = 400
                               window.height = Screen.height
                               window.x = Screen.width - 400
                               window.y = 0
                        }
                     }
                 }
             }
         }
         Row{
             id: buttonId
             anchors.right: parent.right
             anchors.verticalCenter: parent.verticalCenter
             MyIcon {
                 id: minusSquareButtonId
                 myIcon: "qrc:/media/icon/minus.svg"
                 iconType: Style.RoleEnum.IconType.Primary
                 anchors.verticalCenter: closeSquareButtonId.verticalCenter
                 width:28; height:28
                 Connections{
                     target: minusSquareButtonId
                     function onClicked(){
                         window.showMinimized()
                     }
                 }
             }
             MyIcon {
                 id: maximizeSquareButtonId
                 myIcon: (window.visibility === Window.Maximized)? ("qrc:/media/icon/minimize.svg"):
                                                          ("qrc:/media/icon/maximize.svg")
                 iconType: Style.RoleEnum.IconType.Primary
                 anchors.verticalCenter: closeSquareButtonId.verticalCenter
                 width:25; height:25
                 Connections{
                     target: maximizeSquareButtonId
                     function onClicked(){
                         if (window.visibility === Window.Maximized)
                             window.showNormal()
                         else
                             window.showMaximized()
                     }
                 }
             }
             MyIcon {
                 id: closeSquareButtonId
                 myIcon: "qrc:/media/icon/close.svg"
                 iconType: Style.RoleEnum.IconType.Primary
                 width:30; height:30
                 Connections{
                     target: closeSquareButtonId
                     function onClicked(){
                         Qt.quit()
                     }
                 }
             }
         }
    }
}
