import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../../component_library/style" as Style
import "../../../component_library/button"

Item {
    property string selectedFilter: "All"

    Rectangle {
        id: instructionsBox
        anchors.fill: parent
        anchors.margins: 10
        radius: 12
        color: Style.Colors.boxHover
        border.color: "#444"
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
                    delegate: Button {
                        text: modelData
                        checkable: true
                        checked: selectedFilter === modelData
                        onClicked: selectedFilter = modelData
                        font.bold: true
                        background: Rectangle {
                            radius: 6
                            color: checked ? "#007acc" : "#2e2e2e"
                            border.color: checked ? "#00bfff" : "#555"
                            border.width: 1
                        }
                        contentItem: Text {
                            text: modelData
                            color: checked ? "white" : "#ccc"
                            font.bold: true
                            anchors.centerIn: parent
                        }
                        implicitWidth: 80
                        implicitHeight: 30
                    }
                }
            }

            ScrollView {
                id: scrollInstruction
                width: parent.width
                height:  parent.height - rowMethodId.height - 8
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    width: 6
                    contentItem: Rectangle {
                        implicitWidth: 6
                        radius: 3
                        color: "#888"
                    }
                    background: Rectangle {
                        color: "#2e2e2e"
                    }
                }
                TextArea {
                    id: instructionTextBox
                    readOnly: true
                    wrapMode: Text.Wrap
                    textFormat: TextEdit.RichText
                    color: "#e0e0e0"
                    font.family: "Courier New"
                    font.pointSize: 10
                    background: Rectangle {
                        color: "#1e1e1e"
                        radius: 8
                        border.color: "#444"
                    }
                    padding: 10
                    cursorVisible: false
                    persistentSelection: false

                    property string fullLogs:
                        "2025-05-14 10:05:03 [INFO] App started\n" +
                        "2025-05-14 10:05:04 [DEBUG] Initializing model...\n" +
                        "2025-05-14 10:05:05 [INFO] Model ready\n" +
                        "2025-05-14 10:05:06 [ERROR] Connection failed\n" +
                        "2025-05-14 10:05:07 [DEBUG] Retrying connection...\n"

                    function colorizeLine(line) {
                        return line
                            .replace(/^([\d-]+\s[\d:]+)/, function(match) {
                                if (line.indexOf("[INFO]") !== -1)
                                    return "<font color='#98c379'>" + match + "</font>";
                                else if (line.indexOf("[DEBUG]") !== -1)
                                    return "<font color='#61afef'>" + match + "</font>";
                                else if (line.indexOf("[ERROR]") !== -1)
                                    return "<font color='#ff5555'>" + match + "</font>";
                                return match;
                            })
                            .replace(
                                /\[(INFO|DEBUG|ERROR)\]/,
                                function(match) {
                                    if (match === "[INFO]")
                                        return "<font color='#98c379'>" + match + "</font>";
                                    else if (match === "[DEBUG]")
                                        return "<font color='#61afef'>" + match + "</font>";
                                    else if (match === "[ERROR]")
                                        return "<font color='#ff5555'>" + match + "</font>";
                                    return match;
                                }
                            );
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
