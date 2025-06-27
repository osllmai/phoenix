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
                 text: "Phoenix"
                 color: Style.Colors.textTitle
                 anchors.verticalCenter: logoId.verticalCenter
                 font.pixelSize: 14
                 font.styleName: "Bold"
             }
             MyIcon {
                 id: maximizeHSquareButtonId
                 myIcon:  maximizeHSquareButtonId.hovered? "qrc:/media/icon/maximizeHSquareFill.svg":
                                                                                                "qrc:/media/icon/maximizeHSquare.svg"
                 iconType: Style.RoleEnum.IconType.Primary
                 width:28; height:28
                 Connections{
                     target: maximizeHSquareButtonId
                     function onClicked(){

                        if ((window.width !== 400 ) && (window.height !== Screen.height) &&
                                (window.x !== Screen.width - 400) && (window.y !== 0)) {

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
                           } else {
                               window.width = window.prevW
                               window.height = window.prevH
                               window.x = window.prevX
                               window.y = window.prevY
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
                 myIcon: minusSquareButtonId.hovered? "qrc:/media/icon/minusSquareFill.svg":
                                                          "qrc:/media/icon/minusSquare.svg"
                 iconType: Style.RoleEnum.IconType.Primary
                 width:30; height:30
                 Connections{
                     target: minusSquareButtonId
                     function onClicked(){
                         window.showMinimized()
                     }
                 }
             }
             MyIcon {
                 id: maximizeSquareButtonId
                 myIcon: maximizeSquareButtonId.hovered? ("qrc:/media/icon/maximizeSquareFill.svg"):
                                                          ("qrc:/media/icon/maximizeSquare.svg")
                 iconType: Style.RoleEnum.IconType.Primary
                 width:30; height:30
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
                 myIcon: closeSquareButtonId.hovered? "qrc:/media/icon/closeSquareFill.svg":
                                                          "qrc:/media/icon/closeSquare.svg"
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
