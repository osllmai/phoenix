import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

T.Button {
    id: control
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
                MyIcon {
                    id: logoModelId
                    myIcon: model.icon
                    iconType: Style.RoleEnum.IconType.Image
                    enabled: false
                    width: 35; height: 35
                }
                TextArea{
                    id: titleId
                    text: model.title
                    clip: true
                    width: parent.width
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: logoModelId.verticalCenter
                    font.pixelSize: 15
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
                text: model.description
                color: Style.Colors.textInformation
                clip: true
                width: parent.width
                height: 16
                font.pixelSize: 12
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
            }
            Row {
                id: dateAndIconId
                width: parent.width
                height: 20
                spacing: (!control.hovered && model.pinned)? editId.width + deleteId.width:0
                Text {
                    id: dateId
                    text: model.date
                    width: parent.width - editId.width - deleteId.width - pinId.width
                    anchors.verticalCenter: editId.verticalCenter
                    color: Style.Colors.textInformation
                    clip: true
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignJustify
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.NoWrap
                }
                MyIcon {
                    id: editId
                    visible: control.hovered
                    myIcon: editId.hovered? (titleId.readOnly? "qrc:/media/icon/editFill.svg": "qrc:/media/icon/okFill.svg"): (titleId.readOnly? "qrc:/media/icon/edit.svg": "qrc:/media/icon/ok.svg")
                    iconType: Style.RoleEnum.IconType.Primary
                    Connections{
                        target: editId
                        function onClicked(){
                            if(titleId.readOnly){
                                titleId.focus = true;
                                titleId.readOnly = false;
                                titleId.selectByMouse = true;
                            }else{
                                titleId.focus = false;
                                titleId.readOnly = true;
                                titleId.selectByMouse = false;
                                titleId.changeName();
                                conversationList.editTitleRequest(model.id, titleId.text)
                            }
                        }
                    }
                }
                MyIcon {
                    id: deleteId
                    visible: control.hovered
                    myIcon: deleteId.hovered? "qrc:/media/icon/deleteFill.svg": "qrc:/media/icon/delete.svg"
                    iconType: Style.RoleEnum.IconType.Primary
                    Connections{
                        target: deleteId
                        function onClicked(){deleteConversationVerificationId.open()}
                    }
                }
                MyIcon {
                    id: pinId
                    visible: control.hovered || model.pinned
                    width: 27; height: 27
                    y: deleteId.y + 4
                    myIcon: model.pinned? "qrc:/media/icon/pinFill.svg": "qrc:/media/icon/pin.svg"
                    iconType: Style.RoleEnum.IconType.Primary
                    Connections{
                        target: pinId
                        function onClicked(){conversationList.pinnedRequest(model.id, !model.pinned)}
                    }
                }
            }
        }
    }
    VerificationDialog{
        id: deleteConversationVerificationId
        titleText: "delete"
        about:"Are you sure you want to delete the LLM model? \nThis action is irreversible and may result in the loss of data or settings associated with the model."
        textBotton1: "delete"
        textBotton2: "cancel"
        Connections{
            target:deleteConversationVerificationId
            function onButtonAction1(){
                conversationList.deleteRequest(model.id)
            }
            function onButtonAction2() {
                deleteConversationVerificationId.close()
            }
        }
    }
}
