import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style

Item {
    width: parent.width
    height: promptTemplateTextId.height + promptTemplateBox.height
    visible: false
    Column{
        id: modelSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16

        Text {
            id: promptTemplateTextId
            height: 20
            text: qsTr("Prompt template")
            font.pointSize: 10
            color: Style.Colors.textTitle
        }

        Rectangle {
            id: promptTemplateBox
            height: 80
            color: "white"
            radius: 12
            width: parent.width

            ScrollView {
                id: scrollPromptTemplate
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 5
                anchors.bottomMargin: 5

                TextArea {
                    id: promptTemplateTextBox
                    // text: root.currentChat.modelSettings.promptTemplate
                    height: scrollPromptTemplate.height
                    visible: true
                    color: Style.Colors.textTitle
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    wrapMode: Text.WordWrap
                    placeholderText: qsTr("Eg. You are a helpful assistant")
                    clip: false
                    font.pointSize: 10
                    hoverEnabled: true
                    tabStopDistance: 80
                    selectionColor: Style.Colors.textTitle
                    cursorVisible: false
                    persistentSelection: true
                    placeholderTextColor: Style.Colors.textTitle
                    onHeightChanged: {
                        if(promptTemplateBox.height < 70 && promptTemplateTextBox.text !== ""){
                            promptTemplateBox.height += 10;
                        }
                    }
                    background: Rectangle{
                        color: "#00ffffff"
                    }
                }
            }

            // layer.enabled: true
            // layer.effect: Glow {
            //      samples: 15
            //      color: Style.Theme.glowColor
            //      spread: 0.0
            //      transparentBorder: true
            //  }
        }
    }
}
