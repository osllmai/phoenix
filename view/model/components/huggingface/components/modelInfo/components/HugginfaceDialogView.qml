import QtQuick 2.15
import QtQuick.Controls
import '../../../../../../component_library/style' as Style
import "../../../../../../component_library/button"
import "../../components"
import "./../../../../offline/components/components"

Column {
    spacing: 10

    Row {
        id: headerId
        width: parent.width
        height: Math.max(logoModelId.height, likeIconId.height)

        MyIcon {
            id: logoModelId
            myIcon: huggingfaceModelList.hugginfaceInfo?huggingfaceModelList.hugginfaceInfo.icon:""
            iconType: Style.RoleEnum.IconType.Image
            enabled: false
            width: 40; height: 40
        }

        Item {
            width: parent.width - logoModelId.width - likeIconId.width - aboutIcon.width - closeBox.width
            height: parent.height
            Label {
                id: titleId
                text: huggingfaceModelList.hugginfaceInfo?huggingfaceModelList.hugginfaceInfo.name:""
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
                myText: TextArea { text: "localModel/" + (huggingfaceModelList.hugginfaceInfo? huggingfaceModelList.hugginfaceInfo.name:"") }
                anchors.verticalCenter: titleId.verticalCenter
                anchors.right: parent.right
                clip: true
            }
        }

        MyIcon {
            id: aboutIcon
            width: 29; height: 29
            myIcon: aboutIcon.hovered ? "qrc:/media/icon/aboutFill.svg" : "qrc:/media/icon/about.svg"
            anchors.verticalCenter: logoModelId.verticalCenter
            myTextToolTip: (huggingfaceModelList.hugginfaceInfo? huggingfaceModelList.hugginfaceInfo.id:"")
        }

        MyIcon {
            id: likeIconId
            myIcon: "qrc:/media/icon/favorite.svg"
            anchors.verticalCenter: logoModelId.verticalCenter
            iconType: Style.RoleEnum.IconType.Like

            Label {
                text: (huggingfaceModelList.hugginfaceInfo? huggingfaceModelList.hugginfaceInfo.likes:"")
                color: Style.Colors.textTagError
                anchors.top: likeIconId.bottom
                anchors.topMargin: -5
                anchors.horizontalCenter: likeIconId.horizontalCenter
                font.pixelSize: 10
                clip: true
                elide: Label.ElideRight
            }
        }
        MyIcon{
            id: closeBox
            width: 30; height: 30
            myIcon: "qrc:/media/icon/close.svg"
            myTextToolTip: "Close"
            anchors.verticalCenter: logoModelId.verticalCenter
            isNeedAnimation: true
            onClicked: settingsDialogId.close()
        }
    }

    Column {
        id: aboutModel
        anchors.leftMargin: 30
        Label {
            text: "Created at: " + (huggingfaceModelList.hugginfaceInfo? huggingfaceModelList.hugginfaceInfo.createdAt:"")
            color: Style.Colors.textInformation
            font.pixelSize: 10
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
        }
        Label {
            text: "Author: " + (huggingfaceModelList.hugginfaceInfo? huggingfaceModelList.hugginfaceInfo.author:"")
            color: Style.Colors.textInformation
            font.pixelSize: 10
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
        }
        Label {
            text: "Last Modified: " + (huggingfaceModelList.hugginfaceInfo? huggingfaceModelList.hugginfaceInfo.lastModified:"")
            color: Style.Colors.textInformation
            font.pixelSize: 10
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
        }
    }

    ListView {
        id: listView
        width:  parent.width
        height: parent.height - headerId.height

        clip: true

        interactive: listView.contentHeight > listView.height
        boundsBehavior: listView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        flickDeceleration: 200
        maximumFlickVelocity: 12000

        ScrollBar.vertical: ScrollBar {
            policy: listView.contentHeight > listView.height
                    ? ScrollBar.AlwaysOn
                    : ScrollBar.AlwaysOff
        }

        model:  (huggingfaceModelList.hugginfaceInfo? huggingfaceModelList.hugginfaceInfo.siblings:[])
        delegate: Row {
            width: listView.width
            height: 50
            spacing: 10

            Label {
                text: modelData.rfilename
                color: Style.Colors.textInformation
                font.pixelSize: 12
                elide: Label.ElideRight
                width: parent.width - dounloadButton.width - 20
                anchors.verticalCenter: parent.verticalCenter
            }

            DownloadButton{
                id: dounloadButton

                modelId: modelData.exist? modelData.offlineModel.id: -1
                modelName: modelData.exist? modelData.offlineModel.modelName: ""
                modelKey: modelData.exist? modelData.offlineModel.key: ""
                modelType: modelData.exist? modelData.offlineModel.type: ""
                modelIcon: modelData.exist? modelData.offlineModel.icon: ""
                modelPromptTemplate: ""
                modelSystemPrompt: ""
                modelIsDownloading: modelData.exist? modelData.offlineModel.isDownloading: false
                modelDownloadFinished: modelData.exist? modelData.offlineModel.downloadFinished: false
                modelDownloadPercent: modelData.exist? modelData.offlineModel.downloadPercent: 0
                needAddModel: !modelData.exist
            }
        }
    }
}
