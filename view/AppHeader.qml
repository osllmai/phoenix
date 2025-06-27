import QtQuick
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import './component_library/style' as Style
import './component_library/button'

// Item {
//     id: customTitleBar

//     width: parent.width
//     height: 40

//     Rectangle {
//         anchors.fill: parent
//         color: "#333333"
//     }

//     Row {
//         anchors.verticalCenter: parent.verticalCenter
//         anchors.right: parent.right
//         spacing: 10
//         padding: 10

//         Button {
//             text: "—"
//             onClicked: window.showMinimized()
//         }

//         Button {
//             text: window.visibility === Window.Maximized ? "❐" : "□"
//             onClicked: {
//                 if (window.visibility === Window.Maximized)
//                     window.showNormal()
//                 else
//                     window.showMaximized()
//             }
//         }

//         Button {
//             text: "✕"
//             onClicked: Qt.quit()
//         }
//     }

//     MouseArea {
//         anchors.fill: parent
//         property point clickPos: Qt.point(0, 0)

//         onPressed: (mouse) => {
//             clickPos = Qt.point(mouse.x, mouse.y)
//         }

//         onPositionChanged: (mouse) => {
//             var dx = mouse.x - clickPos.x
//             var dy = mouse.y - clickPos.y
//             window.x += dx
//             window.y += dy
//         }
//     }
// }

T.Button {
    id: titleBar
    width: parent.width
    height: 40

    // HoverHandler {
    //     id: hoverHandler
    //     acceptedDevices: PointerDevice.Mouse
    //     cursorShape: Qt.SizeAllCursor
    // }

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
