import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

T.Button {
    id: control
    property var myText: textId.text
    property var modelIcon: "qrc:/media/icon/inDox.svg"
    property var date: "3 Min ago"
    signal deleteChat()
    // signal editChatName(var chatName)

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 8
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: control.hovered? Style.Colors.boxHover: "#00ffffff"

        Row {
            id: headerId
            width: parent.width
            MyIcon {
                id: logoModelId
                myIcon: control.modelIcon
                iconType: Style.RoleEnum.IconType.Primary
                enabled: false
                width: 38; height: 38
            }
            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 2

                TextArea{
                    id: textId
                    text: "prompt"
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: logoModelId.verticalCenter
                    font.pixelSize: 14
                    font.styleName: "Bold"
                    focus: false
                    readOnly: true
                    wrapMode: Text.NoWrap
                    selectByMouse: false

                    background: null
                    // function changeName() {
                    //     control.editChatName(textId.text);
                    //     textId.focus = false;
                    //     textId.readOnly = true;
                    //     textId.selectByMouse = false;
                    // }

                    property bool isEnter: true
                    Accessible.role: Accessible.Button
                    Accessible.name: text
                    Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
                }

                Row {
                    id: dateAndIconId
                    width: parent.width
                    height: 20
                    Text {
                        id: dateId
                        text: control.date
                        width: parent.width - copyId.width
                        anchors.verticalCenter: copyId.verticalCenter
                        color: Style.Colors.textInformation
                        clip: true
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignJustify
                        verticalAlignment: Text.AlignTop
                        wrapMode: Text.NoWrap
                    }
                    // MyIcon {
                    //     id: editId
                    //     visible: control.hovered
                    //     myIcon: editId.hovered? (textId.readOnly? "qrc:/media/icon/editFill.svg": "qrc:/media/icon/okFill.svg"): (textId.readOnly? "qrc:/media/icon/edit.svg": "qrc:/media/icon/ok.svg")
                    //     iconType: Style.RoleEnum.IconType.Primary
                    //     Connections{
                    //         target: editId
                    //         function onClicked(){
                    //             console.log("Edit")
                    //             if(textId.readOnly){
                    //                 textId.focus = true;
                    //                 textId.readOnly = false;
                    //                 textId.selectByMouse = true;
                    //             }else{
                    //                 textId.focus = false;
                    //                 textId.readOnly = true;
                    //                 textId.selectByMouse = false;
                    //                 textId.changeName();
                    //             }
                    //         }
                    //     }
                    // }
                    MyIcon {
                        id: copyId
                        visible: control.hovered
                        myIcon: copyId.hovered? "qrc:/media/icon/deleteFill.svg": "qrc:/media/icon/delete.svg"
                        iconType: Style.RoleEnum.IconType.Primary
                        Connections{
                            target: copyId
                            function onClicked(){console.log("Delete")}
                        }
                    }
                }
            }
        }
    }
}
