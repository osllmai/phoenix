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
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        radius: 12
        color: "#00ffffff"
        border.color: Style.Colors.boxBorder
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8


            ListView {
                id: companyList
                height: 40
                width: parent.width
                spacing: 5
                cacheBuffer: Math.max(0, companyList.contentWidth)

                layoutDirection: Qt.LeftToRight
                orientation: Qt.Horizontal
                snapMode: ListView.SnapToItem

                interactive: contentWidth > width
                boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

                ScrollBar.horizontal: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
                clip: true
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
                footer: MyButton {
                    id: footerItem
                    myText: "..."
                    bottonType: Style.RoleEnum.BottonType.Feature
                    iconType: Style.RoleEnum.IconType.FeatureBlue
                    isNeedAnimation: true
                    checkable: true
                    clip: true
                }
            }

            Item{
                width: parent.width
                height:  parent.height - companyList.height - 8
                ScrollView {
                    id: scrollInstruction
                    anchors.fill: parent
                    clip: true

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    ScrollBar.horizontal: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    TextArea {
                        id: textId
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
                            textId.cursorPosition = textId.length
                        }
                    }
                }
                Row {
                    id: dateAndIconId
                    width: editId.width + copyId.width
                    height: Math.max(editId.height, copyId.height)
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    property bool checkCopy: false

                    MyIcon {
                        id: editId
                        myIcon: editId.hovered? "qrc:/media/icon/editFill.svg": "qrc:/media/icon/edit.svg"
                        iconType: Style.RoleEnum.IconType.Primary
                        width: 26; height: 26
                        Connections{
                            target: editId
                            function onClicked(){
                                editCodeDeveloper.open()
                            }
                        }
                    }

                    MyIcon {
                        id: copyId
                        visible: control.hovered
                        myIcon: copyId.selectIcon()
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

                        Timer {
                            id: successTimer
                            interval: 2000
                            repeat: false
                            onTriggered: dateAndIconId.checkCopy = false
                        }

                        function selectIcon(){
                            if(dateAndIconId.checkCopy === false){
                                return copyId.hovered? "qrc:/media/icon/copyFill.svg": "qrc:/media/icon/copy.svg"
                            }else{
                                return copyId.hovered? "qrc:/media/icon/copySuccessFill.svg": "qrc:/media/icon/copySuccess.svg"
                            }
                        }
                    }
                }
            }
        }
    }
    EditCodeDeveloper{
        id: editCodeDeveloper
    }
}
