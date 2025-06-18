import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../style' as Style
import "../../../button"

Item {
    id: control
    width: 400
    height: 600
    clip: true

    Column{
        anchors.fill: parent
        Flickable {
            id: flickable
            width: parent.width
            height: parent.height - installButton.height
            contentHeight: column.implicitHeight
            clip: true

            interactive: contentHeight > height
            boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

            flickDeceleration: 500
            maximumFlickVelocity: 6000

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            Column {
                id: column
                width: flickable.width
                spacing: 10

                Label {
                    id: availablemodelsId
                    visible: onlineCurrentModelList.height>30
                    text: "Available Models"
                    color: Style.Colors.textTitle
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    clip: true
                }

                OnlineCurrentModelList{
                    id: onlineCurrentModelList
                    model:onlineModelInstallFilter
                }

                Label {
                    id: textId
                    height: 25
                    text: "Recommended"
                    color: Style.Colors.textTitle
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    clip: true
                }

                OnlineCurrentModelList {
                    id: offlinRecommendModelList
                    model: onlineModelListRecommendedFilter
                }
            }
        }
        MyButton{
            id: installButton
            width: parent.width
            myText: "More Models"
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{
                appBodyId.currentIndex = 2
            }
        }

    }
}
