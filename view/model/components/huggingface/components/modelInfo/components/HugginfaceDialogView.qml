import QtQuick 2.15
import QtQuick.Controls
import '../../../../../../component_library/style' as Style
import "../../../../../../component_library/button"
import "../../components"

Column {
    spacing: 10

    Row {
        id: headerId
        width: parent.width
        height: Math.max(logoModelId.height, likeIconId.height)

        MyIcon {
            id: logoModelId
            myIcon: huggingfaceModelList.hugginfaceInfo.icon
            iconType: Style.RoleEnum.IconType.Image
            enabled: false
            width: 40; height: 40
        }

        Item {
            width: parent.width - logoModelId.width - likeIconId.width - aboutIcon.width
            height: parent.height
            Label {
                id: titleId
                visible: !titleAndCopy.visible
                text: huggingfaceModelList.hugginfaceInfo.name
                color: Style.Colors.textTitle
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - copyId.width
                font.pixelSize: 14
                font.styleName: "Bold"
                clip: true
                elide: Label.ElideRight
            }
            MyCopyButton {
                id: copyId
                visible: !titleAndCopy.visible
                myText: TextArea { text: "localModel/" + huggingfaceModelList.hugginfaceInfo.name }
                anchors.verticalCenter: titleId.verticalCenter
                anchors.right: parent.right
                clip: true
            }
            Row {
                id: titleAndCopy
                visible: parent.width - title2Id.implicitWidth - copy2Id.width > 0
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                Label {
                    id: title2Id
                    text: huggingfaceModelList.hugginfaceInfo.name
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14
                    font.styleName: "Bold"
                    clip: true
                    elide: Label.ElideRight
                }
                MyCopyButton {
                    id: copy2Id
                    myText: TextArea { text: "localModel/" + huggingfaceModelList.hugginfaceInfo.name }
                    anchors.verticalCenter: title2Id.verticalCenter
                    clip: true
                }
            }
        }

        MyIcon {
            id: aboutIcon
            width: 29; height: 29
            myIcon: aboutIcon.hovered ? "qrc:/media/icon/aboutFill.svg" : "qrc:/media/icon/about.svg"
            anchors.verticalCenter: logoModelId.verticalCenter
            myTextToolTip: huggingfaceModelList.hugginfaceInfo.id
        }

        MyIcon {
            id: likeIconId
            myIcon: "qrc:/media/icon/favorite.svg"
            anchors.verticalCenter: logoModelId.verticalCenter
            iconType: Style.RoleEnum.IconType.Like

            Label {
                text: huggingfaceModelList.hugginfaceInfo.likes
                color: Style.Colors.textTagError
                anchors.top: likeIconId.bottom
                anchors.topMargin: -5
                anchors.horizontalCenter: likeIconId.horizontalCenter
                font.pixelSize: 10
                clip: true
                elide: Label.ElideRight
            }
        }
    }

    Column {
        anchors.leftMargin: 30
        Label {
            text: "Created at: " + huggingfaceModelList.hugginfaceInfo.createdAt
            color: Style.Colors.textInformation
            font.pixelSize: 10
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
        }
        Label {
            text: "Author: " + huggingfaceModelList.hugginfaceInfo.author
            color: Style.Colors.textInformation
            font.pixelSize: 10
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
        }
        Label {
            text: "Last Modified: " + huggingfaceModelList.hugginfaceInfo.lastModified
            color: Style.Colors.textInformation
            font.pixelSize: 10
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
        }
    }

    Item {
        id: tagsContainer
        width: parent.width
        clip: true

        Flow {
            id: tagsFlow
            anchors.fill: parent
            anchors.topMargin: 4
            spacing: 4
            flow: Flow.LeftToRight
            Repeater {
                model: huggingfaceModelList.hugginfaceInfo.tags
                MyButton {
                    myText: modelData !== undefined && modelData !== null ? modelData.toString() : ""
                    myIcon: ""
                    bottonType: Style.RoleEnum.BottonType.Secondary
                    isNeedAnimation: true
                    height: 20
                }
            }
        }
    }

    ScrollView {
        id: mainScroll
        width: parent.width
        height: 400

        Column {
            id: scrollContent
            width: parent.width
            spacing: 10

            ListView {
                id: listView
                width: parent.width
                height: Math.min(contentHeight, 300)
                interactive: false
                model: huggingfaceModelList.hugginfaceInfo.siblings
                delegate: Row {
                    width: listView.width
                    height: 45
                    spacing: 10

                    Label {
                        text: modelData.rfilename
                        color: Style.Colors.textInformation
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        elide: Label.ElideRight
                        width: parent.width - dounloadButton.width - 20
                    }

                    MyButton {
                        id: dounloadButton
                        myText: "Add Model"
                        bottonType: Style.RoleEnum.BottonType.Primary
                        onClicked: {
                            huggingfaceModelList.addModel(
                                huggingfaceModelList.hugginfaceInfo.id,
                                modelData.rfilename,
                                huggingfaceModelList.hugginfaceInfo.pipeline_tag,
                                huggingfaceModelList.hugginfaceInfo.icon
                            )
                        }
                    }
                }
            }

            Label {
                text: huggingfaceModelList.hugginfaceInfo.readMe
                wrapMode: Text.Wrap
                color: Style.Colors.textInformation
                font.pixelSize: 10
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                width: parent.width
            }
        }
    }
}

