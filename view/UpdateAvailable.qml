import QtQuick
import QtQuick.Templates 2.1 as T

import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import './component_library/style' as Style
import './component_library/button'

T.Button{
    id: backgroundId
    width: Math.max(buttonBoxId.width + 70, 400)
    height:  titleBoxId.height + (informationNotesId.visible?  (informationNotesId.height+20): 10) + buttonBoxId.height + 32

    visible: false
    x: window.width - backgroundId.width - 10
    y: window.height - backgroundId.height - 45
    z: 200

    property int parentWidth: window.width
    onParentWidthChanged: {
        if(backgroundId.visible === true){
            backgroundId.x = window.width - backgroundId.width - 10
        }
    }

    property bool isAvailable: updateChecker.isUpdateAvailable || (updateChecker.notesCurrentVersion !== "")
    property bool isCurrentVersion: !updateChecker.isUpdateAvailable && (updateChecker.notesCurrentVersion !== "")
    onIsAvailableChanged: {
        if (backgroundId.isAvailable) {
            backgroundId.visible = true
            backgroundId.x = window.width
            backgroundId.showAnimatedFunction()
        }
    }

    NumberAnimation {
        id: hideAnimated
        target: backgroundId
        property: "x"
        to: window.width
        duration: 300
        easing.type: Easing.InCubic
        onFinished: {
            backgroundId.visible = false
        }
    }
    NumberAnimation {
        id: showAnimated
        target: backgroundId
        property: "x"
        to: window.width - backgroundId.width - 10
        duration: 300
        easing.type: Easing.OutCubic
        onFinished: {
            backgroundId.x = window.width - backgroundId.width - 10
        }
    }

    Behavior on height{
        NumberAnimation{
            duration: 200
        }
    }

    function showAnimatedFunction() {
        backgroundId.visible = true
        showAnimated.start()
    }

    function hideAnimatedFunction() {
        hideAnimated.start()
    }

    background: null
    contentItem: Rectangle{
        anchors.fill: parent
         radius: 10
         border.width: 1
         border.color: Style.Colors.boxBorder
         color: Style.Colors.background

         Column{
             anchors.fill: parent
             anchors.margins: 16
             spacing: 10

             Row {
                 id: titleBoxId
                 height: titleId.height + infoId.height
                 width: parent.width
                 spacing: 3

                 MyIcon {
                     id: closeBox
                     width: 30
                     height: 30
                     myIcon: backgroundId.hovered
                             ? "qrc:/media/icon/downloadFill.svg"
                             : "qrc:/media/icon/download.svg"
                     isNeedAnimation: true
                 }

                 Column {
                     width: parent.width - closeBox.width

                     Label {
                         id: titleId
                         text: !backgroundId.isCurrentVersion
                               ? "New Version: Phoenix " + updateChecker.latestVersion
                               : "You’re using the latest version — Phoenix " + updateChecker.currentVersion
                         height: 20
                         verticalAlignment: Text.AlignVCenter
                         color: Style.Colors.textTitle
                         font.pixelSize: 14
                         font.styleName: "Bold"
                         clip: true
                     }

                     Label {
                         id: infoId
                         text: !backgroundId.isCurrentVersion
                               ? "A newer version of Phoenix is available. Click to update."
                               : "No updates available at the moment."
                         color: Style.Colors.textInformation
                         width: parent.width
                         font.pixelSize: 12
                         horizontalAlignment: Text.AlignLeft
                         verticalAlignment: Text.AlignTop
                         wrapMode: Text.Wrap
                         clip: true
                     }
                 }
             }


             Label {
                 id: informationNotesId
                 text: (backgroundId.isCurrentVersion)? updateChecker.notesCurrentVersion: updateChecker.notesLatestVersion
                 color: Style.Colors.textTitle
                 lineHeight: 1.4
                 visible: false
                 clip: true
                 width: parent.width
                 font.pixelSize: 12
                 verticalAlignment: Text.AlignTop
                 wrapMode: Text.Wrap
                 horizontalAlignment: Text.AlignJustify
             }

             Row{
                 id: buttonBoxId
                 spacing: 5
                 height: 35
                 anchors.right: parent.right

                 MyButton {
                     id: botton1
                     myText: informationNotesId.visible? "Hide release notes": "Show release notes"
                     bottonType: Style.RoleEnum.BottonType.Secondary
                     onClicked: {
                         informationNotesId.visible = !informationNotesId.visible
                     }
                 }

                 MyButton {
                     id: botton2
                     myText: !backgroundId.isCurrentVersion?"Remind me later": "OK"
                     bottonType: Style.RoleEnum.BottonType.Secondary
                     onClicked: backgroundId.hideAnimatedFunction()
                 }

                 MyButton {
                     id: botton3
                     visible: !backgroundId.isCurrentVersion
                     myText: "Update Now"
                     bottonType: Style.RoleEnum.BottonType.Primary
                     onClicked: {
                         updateChecker.checkForUpdates()
                         backgroundId.hideAnimatedFunction()
                     }
                 }
             }
         }
         layer.enabled: backgroundId.hovered
         layer.effect: Glow {
              samples: 40
              color:  Style.Colors.boxBorder
              spread: 0.1
              transparentBorder: true
          }
     }
}
