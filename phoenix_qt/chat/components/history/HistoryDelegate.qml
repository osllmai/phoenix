import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style

T.Button {
    id: control
    property var title: titleId.text
    property var modelIcon: "../../../media/icon/inDox.svg"
    property var description: "Description"
    property var date: "3 Min ago"
    signal deleteChat()
    signal editChatName(var chatName)

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 8
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: control.hovered? Style.Colors.boxHover: "#00ffffff"

        Column {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 2

            Row {
                id: headerId
                width: parent.width
                ToolButton {
                    id: logoModelId
                    background: null
                    icon {
                        source: control.modelIcon
                        color: Style.Colors.iconHoverAndChecked
                        width: 20; height: 20
                    }
                }
                TextArea{
                    id: titleId
                    text: "chat name"
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: logoModelId.verticalCenter
                    font.pixelSize: 14
                    font.styleName: "Bold"
                    focus: false
                    readOnly: true
                    wrapMode: Text.NoWrap
                    selectByMouse: false

                    background: null
                    function changeName() {
                        control.editChatName(titleId.text);
                        titleId.focus = false;
                        titleId.readOnly = true;
                        titleId.selectByMouse = false;
                    }

                    property bool isEnter: true
                    Accessible.role: Accessible.Button
                    Accessible.name: text
                    Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
                }
            }
            Text {
                id: informationId
                text: control.description
                color: Style.Colors.textInformation
                clip: true
                font.pixelSize: 12
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
            }
            Row {
                id: dateAndIconId
                width: parent.width
                height: 20
                Text {
                    id: dateId
                    text: control.date
                    width: parent.width - editId.width - deleteId.width - pinId.width
                    anchors.verticalCenter: editId.verticalCenter
                    color: Style.Colors.textInformation
                    clip: true
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignJustify
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.NoWrap
                }
                ToolButton {
                    id: editId
                    visible: control.hovered
                    background: null
                    icon {
                        source: editId.hovered? (titleId.readOnly? "../../../media/icon/editFill.svg": "../../../media/icon/okFill.svg"): (titleId.readOnly? "../../../media/icon/edit.svg": "../../../media/icon/ok.svg")
                        color: editId.hovered? Style.Colors.iconHoverAndChecked: Style.Colors.iconNormal
                        width: 18; height: 18
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{
                            console.log("Edit")
                            if(titleId.readOnly){
                                titleId.focus = true;
                                titleId.readOnly = false;
                                titleId.selectByMouse = true;
                            }else{
                                titleId.focus = false;
                                titleId.readOnly = true;
                                titleId.selectByMouse = false;
                                titleId.changeName();
                            }
                        }
                    }
                }
                ToolButton {
                    id: deleteId
                    visible: control.hovered
                    background: null
                    icon {
                        source: deleteId.hovered? "../../../media/icon/deleteFill.svg": "../../../media/icon/delete.svg"
                        color: deleteId.hovered? Style.Colors.iconHoverAndChecked: Style.Colors.iconNormal
                        width: 18; height: 18
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{console.log("Delete")}
                    }
                }
                ToolButton {
                    id: pinId
                    y: deleteId.y + 4
                    visible: control.hovered
                    background: null
                    icon {
                        source: pinId.hovered? "../../../media/icon/pinFill.svg": "../../../media/icon/pin.svg"
                        color: pinId.hovered? Style.Colors.iconHoverAndChecked: Style.Colors.iconNormal
                        width: 14; height: 14
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{console.log("Pin")}
                    }
                }
            }
        }
    }

}
