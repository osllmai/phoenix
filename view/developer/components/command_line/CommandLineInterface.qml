import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../../component_library/style" as Style
import "../../../component_library/button"

Item {
    id: control
    property string selectedFilter: "All"

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
                    model: ["All", "Info", "Debug", "Error"]

                    delegate: MyButton {
                        id: delegateId
                        myText: modelData
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureBlue
                        isNeedAnimation: true
                        checkable: true
                        checked: control.selectedFilter === modelData
                        onClicked: control.selectedFilter = modelData
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
                TextArea {
                    id: instructionTextBox
                    readOnly: true
                    wrapMode: Text.Wrap
                    textFormat: TextEdit.RichText
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

                    property string fullLogs: Logger.developerLogs

                    function colorizeLine(line, colors) {
                        return line
                            .replace(/^([\d-]+\s[\d:]+)/, function(match) {
                                if (line.indexOf("[INFO]") !== -1)
                                    return "<b><font color='" + Style.Colors.textTagInfo + "'>" + match + "</font></b>";
                                else if (line.indexOf("[DEBUG]") !== -1)
                                    return "<b><font color='" + Style.Colors.textTagDebug + "'>" + match + "</font></b>";
                                else if (line.indexOf("[ERROR]") !== -1)
                                    return "<b><font color='" + Style.Colors.textTagError + "'>" + match + "</font></b>";
                                return match;
                            })
                            .replace(/\[(INFO|DEBUG|ERROR)\]/, function(match) {
                                if (match === "[INFO]")
                                    return "<b><font color='" + Style.Colors.textTagInfo + "'>" + match + "</font></b>";
                                else if (match === "[DEBUG]")
                                    return "<b><font color='" + Style.Colors.textTagDebug + "'>" + match + "</font></b>";
                                else if (match === "[ERROR]")
                                    return "<b><font color='" + Style.Colors.textTagError + "'>" + match + "</font></b>";
                                return match;
                            });
                    }

                    function getFilteredLogs(type) {
                        let lines = fullLogs.split("\n");
                        if (type !== "All") {
                            lines = lines.filter(function (line) {
                                return line.indexOf("[" + type.toUpperCase() + "]") !== -1;
                            });
                        }
                        return lines.map(colorizeLine).join("<br>");
                    }

                    text: getFilteredLogs(selectedFilter)

                    Connections {
                        target: instructionsBox
                        onSelectedFilterChanged: {
                            instructionTextBox.text = instructionTextBox.getFilteredLogs(selectedFilter)
                        }
                    }

                    onTextChanged: {
                        instructionTextBox.cursorPosition = instructionTextBox.length
                    }
                }

            }
        }
    }
}
