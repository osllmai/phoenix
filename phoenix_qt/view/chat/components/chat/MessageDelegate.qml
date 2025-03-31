import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 6.6
import QtTextToSpeech

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
                TextArea {
                    id: textId
                    text: model.text
                    color: Style.Colors.textTitle
                    selectionColor: "blue"
                    selectedTextColor: "white"
                    width: parent.width - logoModelId.width
                    font.pixelSize: 14
                    focus: false
                    readOnly: true
                    wrapMode: TextEdit.Wrap
                    textFormat: TextEdit.MarkdownText
                    selectByMouse: true
                    background: null
                    Accessible.role: Accessible.Button
                    Accessible.name: text
                    Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")

                    onLinkActivated: function(url) {
                        Qt.openUrlExternally(url)
                    }
                }

                Row {
                    id: dateAndIconId
                    width: dateId.width + copyId.width
                    height: Math.max(dateId.height, copyId.height)
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    property bool checkCopy: false
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
                        function selectIcon(){
                            if(dateAndIconId.checkCopy == false){
                                return copyId.hovered? "qrc:/media/icon/copyFill.svg": "qrc:/media/icon/copy.svg"
                            }else{
                                return copyId.hovered? "qrc:/media/icon/copySuccessFill.svg": "qrc:/media/icon/copySuccess.svg"
                            }
                        }
                    }
                    MyIcon {
                        id: likeId
                        visible: control.hovered
                        myIcon: "qrc:/media/icon/like.svg"
                        iconType: Style.RoleEnum.IconType.Primary
                        width: 26; height: 26
                        Connections{
                            target: likeId
                            function onClicked(){
                            }
                        }
                    }
                    MyIcon {
                        id: disLikeId
                        visible: control.hovered
                        myIcon: "qrc:/media/icon/disLike.svg"
                        iconType: Style.RoleEnum.IconType.Primary
                        width: 26; height: 26
                        Connections{
                            target: disLikeId
                            function onClicked(){
                            }
                        }
                    }
                    MyIcon {
                        id: speakerId
                        visible: control.hovered
                        myIcon: speakerId.selectIcon()
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
                            id: successTimer
                            interval: 1000
                            repeat: false
                            onTriggered: dateAndIconId.checkCopy = false
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
