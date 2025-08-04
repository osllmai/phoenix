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
            height: 80; width: parent.width
            color: Style.Colors.boxHover
            border.width: 0
            border.color: Style.Colors.boxBorder
            radius: 12
            ScrollView {
                id: scrollInput
                width: parent.width
                height: parent.height
                ScrollBar.vertical.interactive: true

                ScrollBar.vertical.policy: scrollInput.contentHeight > scrollInput.height
                                           ? ScrollBar.AlwaysOn
                                           : ScrollBar.AlwaysOff

                ScrollBar.vertical.active: (scrollInput.contentY > 0) &&
                                (scrollInput.contentY < scrollInput.contentHeight - scrollInput.height)

                TextArea {
                    id: promptTemplateTextBox
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
                    onHeightChanged: {
                        if(promptTemplateBox.height < 70 && promptTemplateTextBox.text !== ""){
                            promptTemplateBox.height += 10;
                        }
                    }
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
}
