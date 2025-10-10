import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import '../../../style' as Style
import '../../../button'
import '../../../../model/components/online/components/components'

Dialog {
    id: settingsDialogId
    x: (window.width - width) / 2
    y: (window.height - height) / 2
    width: Math.min( 600 , window.width-40)
    height: Math.min( 50 , window.height-40)

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        width: window.width
        height: window.height - 40
        y: 40
        color: Style.Colors.overlayDrawer
    }

    background: null
    contentItem: Rectangle {
        id: control
        anchors.fill: parent
        color: Style.Colors.boxNormalGradient0
        border.width: 1
        border.color: Style.Colors.boxBorder
        radius: 8

        function onSaveAPIKey(apiKey){
            onlineCompanyList.saveAPIKey(model.id, apiKey)
            inputApikeyDialogId.close()
            if(model.installModel){
                modelSelectViewId.setModelRequest(model.id, model.name, model.icon, model.promptTemplate, model.systemPrompt)
            }
        }

        property bool check: false
        property bool isPasswordMode: false

        function selectIcon() {
            if (control.check === true) {
                return iconId.hovered ? "qrc:/media/icon/okFill.svg" : "qrc:/media/icon/okFill.svg"
            } else {
                return iconId.hovered ? "qrc:/media/icon/sendFill.svg" : "qrc:/media/icon/send.svg"
            }
        }

        function sendAPIKey() {
            control.check = true
            successTimer.start()
        }

        Row {
            anchors.fill: parent

            TextField {
                id: apiKeyField
                width: parent.width - iconId.width - (seeId.visible? seeId.width:0) - 5
                anchors.verticalCenter: iconId.verticalCenter

                placeholderText: qsTr("Enter API Key")
                placeholderTextColor: Style.Colors.menuNormalIcon
                persistentSelection: true
                selectionColor: Style.Colors.textSelection
                color: Style.Colors.menuNormalIcon
                font.pointSize: 10
                background: null

                echoMode: control.isPasswordMode ? TextInput.Password : TextInput.Normal

                Keys.onReturnPressed: (event) => {
                    if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier || (apiKeyField.text === "")) {
                        event.accepted = false;
                    } else {
                        control.sendAPIKey()
                    }
                }
            }

            MyIcon {
                id: seeId
                visible: apiKeyField.text !== ""
                anchors.verticalCenter: parent.verticalCenter
                myIcon: control.isPasswordMode? "qrc:/media/icon/visiblePassword.svg" : "qrc:/media/icon/eyePassword.svg"
                width: 28
                height: 28

                onClicked: {
                    if(apiKeyField.text !== ""){
                        control.isPasswordMode = !control.isPasswordMode
                    }
                }
            }

            MyIcon {
                id: iconId
                anchors.verticalCenter: parent.verticalCenter
                myIcon: control.selectIcon()
                width: 28
                height: 28

                onClicked: {
                    control.sendAPIKey()
                }
            }
        }

        Timer {
            id: successTimer
            interval: 1000
            repeat: false
            onTriggered: {
                control.onSaveAPIKey(apiKeyField.text)
                control.check = false
            }
        }

        layer.enabled: false
        layer.effect: Glow {
            samples: 40
            color: Style.Colors.boxBorder
            spread: 0.1
            transparentBorder: true
        }
    }






    //     InputApikey{
    //     id: inputApikey
    //     anchors.fill: parent
    //     Connections{
    //         target: inputApikey
    //         function onSaveAPIKey(apiKey){
    //             onlineCompanyList.saveAPIKey(model.id, apiKey)
    //             inputApikeyDialogId.close()
    //             if(model.installModel){
    //                 modelSelectViewId.setModelRequest(model.id, model.name, model.icon, model.promptTemplate, model.systemPrompt)
    //             }
    //         }
    //     }
    // }
}
