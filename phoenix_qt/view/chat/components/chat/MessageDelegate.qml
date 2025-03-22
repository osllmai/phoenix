import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 6.6

import '../../../component_library/style' as Style
import '../../../component_library/button'

T.Button {
    id: control
    height: textId.height + dateAndIconId.height  + 2
    width: parent.width

    background: null
     contentItem: Rectangle {
         id: backgroundId
         anchors.fill: parent
         color: "#00ffffff"

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
            Column {
                spacing: 2
                width: parent.width
                TextArea{
                    id: textId
                    text: model.text
                    color: Style.Colors.textTitle
                    selectionColor: "blue"
                    selectedTextColor: "white"
                    width:  parent.width - logoModelId.width
                    font.pixelSize: 14
                    focus: false
                    readOnly: true
                    wrapMode: Text.Wrap
                    textFormat: TextEdit.RichText
                    selectByMouse: true
                    background: null
                    Accessible.role: Accessible.Button
                    Accessible.name: text
                    Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
                }

                Row {
                    id: dateAndIconId
                    width: dateId.width + copyId.width
                    height: Math.max(dateId.height, copyId.height)
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    property bool checkCopy: false
                    Text {
                        id: dateId
                        visible: control.hovered
                        text: model.date
                        anchors.verticalCenter: copyId.verticalCenter
                        color: Style.Colors.textInformation
                        clip: true
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignJustify
                        verticalAlignment: Text.AlignTop
                        wrapMode: Text.NoWrap
                    }
                    MyIcon {
                        id: copyId
                        visible: control.hovered
                        myIcon: selectIcon()
                        iconType: Style.RoleEnum.IconType.Primary
                        width: 26; height: 26
                        Connections{
                            target: copyId
                            function onClicked(){
                                textId.selectAll()
                                textId.copy()
                                textId.deselect()
                                dateAndIconId.checkCopy= true
                                successTimer.start();
                            }
                        }
                        function selectIcon(){
                            if(dateAndIconId.checkCopy == false){
                                return copyId.hovered? "qrc:/media/icon/copyFill.svg": "qrc:/media/icon/copy.svg"
                            }else{
                                return copyId.hovered? "qrc:/media/icon/copySuccessFill.svg": "qrc:/media/icon/copySuccess.svg"
                            }
                        }
                    }
                    Timer {
                        id: successTimer
                        interval: 2000
                        repeat: false
                        onTriggered: dateAndIconId.checkCopy= false
                    }
                }
            }
        }
     }
}
