import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../style' as Style

Item {
    id: control
    width: parent.width
    height: promptTemplateTextId.height + promptTemplateBox.height
    visible: false

    Column{
        id: modelSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16

        Label {
            id: promptTemplateTextId
            height: 20
            text: qsTr("Prompt template")
            font.pointSize: 10
            color: Style.Colors.textTitle
        }

        Rectangle {
            id: promptTemplateBox
            height: Math.max(80 , promptTemplateTextBox.height); width: parent.width
            color: Style.Colors.boxHover
            border.width: 0
            border.color: Style.Colors.boxBorder
            radius: 12

            TextArea {
                id: promptTemplateTextBox
                width: parent.width
                text: modelSettingsId.promptTemplate
                visible: true
                color: Style.Colors.textInformation
                wrapMode: Text.Wrap
                placeholderText: qsTr("Eg. You are a helpful assistant")
                clip: true
                font.pointSize: 10
                hoverEnabled: true
                tabStopDistance: 80
                persistentSelection: true
                selectionColor: Style.Colors.textSelection
                placeholderTextColor: promptTemplateTextBox.text ===""? Style.Colors.menuNormalIcon: Style.Colors.textPlaceholder
                background: null
                onTextChanged: {
                    modelSettingsId.updatePromptTemplate(promptTemplateTextBox.text.replace(/\\n/g, "\n"))
                }
                onEditingFinished: {
                    promptTemplateBox.border.width = 0
                }
                onPressed: {
                    promptTemplateBox.border.width = 1
                }
            }
        }
    }
}
