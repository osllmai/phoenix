import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import '../../../../../component_library/style' as Style
import '../../../../../component_library/button'

Rectangle {
    id: control
    height: 32
    width: parent.width
    color: Style.Colors.boxNormalGradient0
    border.width: 1
    border.color: Style.Colors.boxBorder
    radius: 8

    signal saveAPIKey(var text)

    property string providerId: onlineBodyId.providerId
    onProviderIdChanged: {
        apiKeyField.text = onlineBodyId.providerKey
        control.check = false
    }

    property bool check: false
    property bool isPasswordMode: false

    function selectIcon() {
        if (onlineBodyId.installProvider === true) {
            return iconId.hovered ? "qrc:/media/icon/deleteFill.svg" : "qrc:/media/icon/delete.svg"
        } else if (control.check === true) {
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
            text: onlineBodyId.providerKey

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
            visible: onlineBodyId.installProvider || apiKeyField.text !== ""
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
                if(onlineBodyId.installProvider === true){
                    deleteDialogLoader.active = true
                    deleteDialogLoader.item.open()
                }else{
                    control.sendAPIKey()
                }
            }
        }
    }

    Timer {
        id: successTimer
        interval: 1000
        repeat: false
        onTriggered: {
            control.saveAPIKey(apiKeyField.text)
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


    Loader {
        id: deleteDialogLoader
        active: false
        sourceComponent: VerificationDialog {
            id: deleteApikeylVerificationId
            titleText: "Delete"
            about: "Do you really want to delete these Api Key?"
            textBotton1: "Cancel"
            textBotton2: "Delete"
            Connections {
                target: deleteApikeylVerificationId
                function onButtonAction1() { deleteApikeylVerificationId.close() }
                function onButtonAction2() {
                    onlineCompanyList.deleteRequest(onlineBodyId.providerId)
                    deleteApikeylVerificationId.close()
                    apiKeyField.text = ""
                }
            }
        }
    }
}
