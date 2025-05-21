import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item {
    id: control

    Rectangle {
        id: instructionsBox
        anchors.fill: parent
        anchors.margins: 10
        radius: 12
        color: "#00ffffff"
        border.color: Style.Colors.boxBorder
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            RowLayout {
                id: rowMethodId
                spacing: 6

                Repeater {
                    model: codeDeveloperList

                    delegate: MyButton {
                        id: delegateId
                        myText: model.name
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureBlue
                        isNeedAnimation: true
                        checkable: true
                        checked: codeDeveloperList.currentProgramLanguage.name === model.name
                        onClicked: codeDeveloperList.setCurrentLanguage(model.id)
                    }
                }
            }

            ScrollView {
                id: scrollInstruction
                width: parent.width
                height:  parent.height - rowMethodId.height - 8
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    // width: 6
                    // contentItem: Rectangle {
                    //     implicitWidth: 6
                    //     radius: 3
                    //     color: "#888"
                    // }
                    // background: Rectangle {
                    //     color: "#2e2e2e"
                    // }
                }

                ScrollBar.horizontal: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    // height: 6
                    // contentItem: Rectangle {
                    //     implicitHeight: 6
                    //     radius: 3
                    //     color: "#888"
                    // }
                    // background: Rectangle {
                    //     color: "#2e2e2e"
                    // }
                }

                TextArea {
                    id: instructionTextBox
                    width: scrollInstruction.width
                    height: implicitHeight
                    readOnly: true
                    wrapMode: Text.NoWrap
                    color: Style.Colors.textInformation
                    font.family: "Courier New"
                    font.pointSize: 10
                    background: Rectangle {
                        radius: 8
                        color: Style.Colors.boxNormalGradient0
                        border.color: Style.Colors.boxBorder
                    }
                    padding: 10
                    cursorVisible: false
                    persistentSelection: false
                    clip: true

                    text: !codeDeveloperList.currentProgramLanguage.codeGenerator? "": codeDeveloperList.currentProgramLanguage.codeGenerator.text

                    onTextChanged: {
                        instructionTextBox.cursorPosition = instructionTextBox.length
                    }
                }
            }
        }
    }
}
