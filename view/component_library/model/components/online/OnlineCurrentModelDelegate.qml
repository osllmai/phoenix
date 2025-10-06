import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../../../style' as Style
import '../../../button'

T.Button {
    id: control

    onClicked: {
        if (model.installModel) {
            modelSelectViewId.setModelRequest(
                model.id,
                model.name,
                model.icon,
                model.promptTemplate,
                model.systemPrompt
            )
        }
    }

    property bool checkselectItem: modelSelectViewId.modelSelect && (modelSelectViewId.modelId === model.id)

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 8
        border.width: 1
        border.color: control.checkselectItem
                       ? Style.Colors.buttonFeatureBorderSelected
                       : Style.Colors.buttonFeatureBorderNormal
        color: (control.hovered || control.checkselectItem)
               ? Style.Colors.boxHover
               : "#00ffffff"

        Row {
            id: headerId
            anchors.verticalCenter: parent.verticalCenter

            MyIcon {
                id: logoModelId
                myIcon: model.icon
                iconType: Style.RoleEnum.IconType.Image
                enabled: false
                width: 32; height: 32
            }

            Label {
                id: modelNameId
                text: /*onlineModelList.currentModel.name*/ model.name
                width: backgroundId.width -
                       logoModelId.width -
                       (copyId.visible? copyId.width: 0) -
                       // onlineModelListComboBox.width -
                       // (model.name === "Indox Router" ? onlineModelListComboBox.width : 0) -
                       (rejectChatButtonLoader.status === Loader.Ready ? rejectChatButtonLoader.item.width : 0) -
                       (installButtonLoader.status === Loader.Ready ? installButtonLoader.item.width : 0) - 5
                clip: true
                elide: Label.ElideRight
                color: Style.Colors.textTitle
                font.pixelSize: 12
                font.bold: control.checkselectItem
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                anchors.verticalCenter: logoModelId.verticalCenter
            }

            // Loader {
            //     id:c0mpanyLouder
            //     active: model.name === "Indox Router"
            //     visible: model.name === "Indox Router"

            //     sourceComponent: OnlineModelListComboBox {
            //         id: onlineCompanyListComboBox
            //         smallComboBox: true
            //         myModel: onlineCompanyListFilter
            //     }
            // }

            // OnlineModelListComboBox {
            //     id: onlineModelListComboBox
            //     smallComboBox: true
            //     myModel: (c0mpanyLouder.active ? onlineCompanyList.currentCompany.onlineModelList : onlineModelList)
            // }

            MyCopyButton {
                id: copyId
                visible: model.installModel
                myText: TextArea { text: model.name/*((model.name === "Indox Router")? (onlineCompanyList.currentCompany.onlineModelList.currentModel.modelName) : onlineModelList.currentModel.modelName)*/ }
                anchors.verticalCenter: logoModelId.verticalCenter
            }

            Loader {
                id: rejectChatButtonLoader
                active: model.id === modelSelectViewId.modelId && model.installModel
                anchors.verticalCenter: logoModelId.verticalCenter
                sourceComponent: MyButton {
                    id: rejectChatButton
                    height: 30
                    myText: "Eject"
                    bottonType: Style.RoleEnum.BottonType.Secondary
                    onClicked: {
                        modelSelectViewId.setModelRequest(-1, "", "", "", "")
                    }
                }
            }

            Loader {
                id: installButtonLoader
                active: !model.installModel
                anchors.verticalCenter: logoModelId.verticalCenter
                sourceComponent: MyIcon {
                    id: installButton
                    height: copyId.width
                    width: copyId.width
                    // myText: "Install"
                    myIcon: "qrc:/media/icon/key.svg"
                    iconType: Style.RoleEnum.BottonType.Primary
                    onClicked: {
                        deleteDialogLoader.active = true
                        deleteDialogLoader.item.open()
                    }
                }
            }
        }
    }

    Loader {
        id: deleteDialogLoader
        active: false
        sourceComponent: InputApikeyDialog {
            id: inputApikeyDialogId
        }
    }
}
