import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../../../style' as Style
import '../../../button'

T.Button {
    id: control

    onClicked: {
        onlineModelList.selectCurrentModelRequest(model.id)
        console.log("Selected:", model.name, "id:", model.id)
    }

    property bool checkselectItem: onlineModelList.currentModel &&
                                   (onlineModelList.currentModel.id === model.id)

    contentItem: Label {
        text: "   " + model.name
        color: Style.Colors.textInformation
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        id: backgroundId
        color: Style.Colors.background
        border.width: 1; border.color: Style.Colors.boxBorder
        radius: 10
    }
    /*Rectangle {
        id: backgroundId
        anchors.fill: parent
        anchors.margins: 5
        radius: 8
        border.width: 1
        border.color: control.checkselectItem? Style.Colors.buttonFeatureBorderSelected: Style.Colors.buttonFeatureBorderNormal
        color: (control.hovered || control.checkselectItem)? Style.Colors.boxHover: "#00ffffff"

        Row {
            id: headerId
            anchors.verticalCenter: parent.verticalCenter
            Label {
                id: modelNameId
                text: model.name
                width: backgroundId.width - copyId.width
                clip: true
                elide: Label.ElideRight
                color: Style.Colors.textTitle
                font.pixelSize: 12
                font.bold: control.checkselectItem? true: false
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                anchors.verticalCenter: parent.verticalCenter
            }
            MyCopyButton{
                id: copyId
                myText: TextArea{text: model.company.name + "/" + model.modelName;}
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }*/

    // function choiceBackgroundColor(state) {
    //     switch (state) {
    //             case Style.RoleEnum.State.Normal:
    //                 return Style.Colors.buttonSecondaryNormal;

    //             case Style.RoleEnum.State.Hover:
    //                 return Style.Colors.buttonSecondaryHover;

    //             case Style.RoleEnum.State.Pressed:
    //                 return Style.Colors.buttonSecondaryPressed;

    //             case Style.RoleEnum.State.Disabled:
    //                 return Style.Colors.buttonSecondaryDisabled;

    //             case Style.RoleEnum.State.Selected:
    //                     return Style.Colors.buttonSecondarySelected;

    //             default:
    //                 return Style.Colors.buttonSecondaryNormal;
    //         }
    // }

    // function choiceTextColor(state) {
    //     switch (state) {
    //             case Style.RoleEnum.State.Normal:
    //                 return Style.Colors.buttonSecondaryTextNormal;

    //             case Style.RoleEnum.State.Hover:
    //                 return Style.Colors.buttonSecondaryTextHover;

    //             case Style.RoleEnum.State.Pressed:
    //                 return Style.Colors.buttonSecondaryTextPressed;

    //             case Style.RoleEnum.State.Disabled:
    //                 return Style.Colors.buttonSecondaryTextDisabled;

    //             case Style.RoleEnum.State.Selected:
    //                 return Style.Colors.buttonSecondaryTextSelected;

    //             default:
    //                 return Style.Colors.buttonSecondaryTextNormal;
    //         }
    // }

    // property bool isNormal: !control.hovered && !control.pressed && control.enabled
    // property bool isHover: control.hovered && !control.pressed && control.enabled
    // property bool isPressed: control.pressed && control.enabled
    // property bool isDisabled: !control.enabled

    // states: [
    //     State {
    //         name: "normal"
    //         when: control.isNormal
    //         PropertyChanges {
    //             target: backgroundId
    //             color: control.choiceBackgroundColor(Style.RoleEnum.State.Normal)
    //             border.color: control.choiceBackgroundColor(Style.RoleEnum.State.Normal)
    //             // width: control.width-3; height: control.height-3
    //         }
    //         PropertyChanges {
    //             target: textId
    //             color: control.choiceTextColor(Style.RoleEnum.State.Normal)
    //         }
    //     },
    //     State {
    //         name: "hover"
    //         when: control.isHover
    //         PropertyChanges {
    //             target: backgroundId
    //             color: control.choiceBackgroundColor(Style.RoleEnum.State.Hover)
    //             border.color: control.choiceBackgroundColor(Style.RoleEnum.State.Hover)
    //             // width: control.isNeedAnimation? control.width: parent.width-3; height: control.isNeedAnimation? control.height: control.height-3
    //         }
    //         PropertyChanges {
    //             target: textId
    //             color: control.choiceTextColor(Style.RoleEnum.State.Normal)
    //         }
    //     },
    //     State {
    //         name: "pressed"
    //         when: control.isPressed
    //         PropertyChanges {
    //             target: backgroundId
    //             color: control.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
    //             border.color: control.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
    //             // width: control.isNeedAnimation? control.width: parent.width-3; height: control.isNeedAnimation? control.height: control.height-3
    //         }
    //         PropertyChanges {
    //             target: textId
    //             color: control.choiceTextColor(Style.RoleEnum.State.Normal)
    //         }
    //     },
    //     State {
    //         name: "disabled"
    //         when: control.isDisabled
    //         PropertyChanges {
    //             target: backgroundId
    //             color: control.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
    //             border.color: control.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
    //             // width: control.width-3; height: control.height-3
    //         }
    //         PropertyChanges {
    //             target: textId
    //             color: control.choiceTextColor(Style.RoleEnum.State.Normal)
    //         }
    //     }
    // ]
}
