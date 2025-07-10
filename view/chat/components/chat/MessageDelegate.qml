import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 6.6
import QtTextToSpeech
import MyMessageTextProcessor 1.0

import '../../../component_library/style' as Style
import '../../../component_library/button'

T.Button {
    id: control
    height: textId.height + dateAndIconId.height  + 2
    width: Math.min(670, parent.width - 48)
    anchors.horizontalCenter: parent.horizontalCenter

    background: null
     contentItem: Item {
         id: backgroundId
         anchors.fill: parent

         MessageTextProcessor {
             id: textProcessor
         }

         Connections {
             target: model
             function onTextChanged() {
                 textProcessor.setValue(model.text)
             }
         }

        Row {
            id: headerId
            width: parent.width
            MyIcon {
                id: logoModelId
                visible: model.icon !== "qrc:/media/image_company/user.svg"
                myIcon: model.icon
                iconType: Style.RoleEnum.IconType.Image
                enabled: false
                width: 35; height: 35
            }
            ToolButton {
                id: phoenixIconId
                visible: model.icon === "qrc:/media/image_company/user.svg"
                width: 35; height: 35
                background: null
                icon{
                    source: model.icon
                    color: Style.Colors.menuHoverAndCheckedIcon
                    width:24; height:24
                }
            }
            Column {
                spacing: 2
                width: parent.width

                TextArea {
                    id: textId
                    color: Style.Colors.textTitle
                    selectionColor: "blue"
                    selectedTextColor: "white"
                    width: parent.width - logoModelId.width
                    font.pixelSize: 14
                    focus: false
                    readOnly: true
                    wrapMode: TextEdit.WordWrap
                    textFormat: TextEdit.PlainText

                    cursorVisible: (!conversationList.isEmptyConversation && conversationList.currentConversation.responseInProgress) ? conversationList.currentConversation.responseInProgress: false
                    cursorPosition: text.length

                    selectByMouse: true
                    background: null

                    Accessible.role: Accessible.Button
                    Accessible.name: text
                    Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")

                    onLinkActivated: function(url) {
                        Qt.openUrlExternally(url)
                    }

                    Component.onCompleted: {
                        textProcessor.textDocument = textId.textDocument
                        textProcessor.setValue(model.text)
                    }
                }

                Row {
                    id: dateAndIconId
                    width: dateId.width + copyId.width
                    height: Math.max(dateId.height, copyId.height)
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    Label {
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
                    MyCopyButton{
                        id: copyId
                        visible: control.hovered
                        myText: textId
                    }
                    MyIcon {
                        id: likeId
                        visible: control.hovered && (model.like>=0)
                        myIcon: (model.like === 0)? "qrc:/media/icon/like.svg": "qrc:/media/icon/likeFill.svg"
                        myTextToolTip: "Like"
                        iconType: Style.RoleEnum.IconType.Primary
                        width: 26; height: 26
                        Connections{
                            target: likeId
                            function onClicked(){
                                if(model.like === 0)
                                    conversationList.likeMessageRequest(conversationList.currentConversation.id, model.id, +1)
                                else
                                    conversationList.likeMessageRequest(conversationList.currentConversation.id, model.id, 0)
                            }
                        }
                    }
                    MyIcon {
                        id: disLikeId
                        visible: control.hovered && (model.like<=0)
                        myIcon: (model.like === 0)? "qrc:/media/icon/disLike.svg": "qrc:/media/icon/disLikeFill.svg"
                        myTextToolTip: "DisLike"
                        iconType: Style.RoleEnum.IconType.Primary
                        width: 26; height: 26
                        Connections{
                            target: disLikeId
                            function onClicked(){
                                if(model.like === 0)
                                    conversationList.likeMessageRequest(conversationList.currentConversation.id, model.id, -1)
                                else
                                    conversationList.likeMessageRequest(conversationList.currentConversation.id, model.id, 0)
                            }
                        }
                    }
                    MyIcon {
                        id: speakerId
                        visible: control.hovered
                        myIcon: speakerId.selectIcon()
                        myTextToolTip: "Speaker"
                        iconType: Style.RoleEnum.IconType.Primary
                        width: 26
                        height: 26
                        enabled: true

                        Connections {
                            target: speakerId
                            function onClicked() {
                                if (!textId.text || textId.text.length === 0)
                                    return

                                let voices = textToSpeechId.availableVoices()
                                if (voices.length === 0)
                                    return

                                let indexOfVoice = voices.indexOf(textToSpeechId.voice)
                                if (indexOfVoice === -1)
                                    indexOfVoice = 0

                                textToSpeechId.voice = voices[indexOfVoice]

                                if (textToSpeechId.state !== TextToSpeech.Speaking) {

                                    textToSpeechId.say(textId.text)
                                    textToSpeechId.messageId = model.id
                                } else if (textToSpeechId.messageId === model.id) {
                                    textToSpeechId.pause()
                                } else {
                                    textToSpeechId.pause()
                                    speakerTimer.start()
                                }
                            }
                        }

                        Timer {
                            id: speakerTimer
                            interval: 1000
                            repeat: false
                            onTriggered: speakerId.clicked()
                        }

                        function selectIcon() {
                            if ((textToSpeechId.state === TextToSpeech.Speaking) && (textToSpeechId.messageId === model.id)) {
                                return speakerId.hovered ? "qrc:/media/icon/stopFill.svg" : "qrc:/media/icon/stop.svg"
                            } else {
                                return speakerId.hovered ? "qrc:/media/icon/speakerFill.svg" : "qrc:/media/icon/speaker.svg"
                            }
                        }
                    }
                }
            }
        }
    }
}
