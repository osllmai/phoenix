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

            interactive: flickable.contentHeight > flickable.height
            boundsBehavior: flickable.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

            flickDeceleration: 200
            maximumFlickVelocity: 12000

            ScrollBar.vertical: ScrollBar {
                policy: flickable.contentHeight > flickable.height
                        ? ScrollBar.AlwaysOn
                        : ScrollBar.AlwaysOff
            }

            Column {
                id: column
                width: flickable.width
                spacing: 10

                Label {
                    id: availablemodelsId
                    visible: offlineFinishedDownloadModelList.height>30
                    text: "Available Models"
                    color: Style.Colors.textTitle
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    clip: true
                }

                OfflineCurrentModelList {
                    id: offlineFinishedDownloadModelList
                    model: offlineModelListFinishedDownloadFilter
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

                OfflineCurrentModelList {
                    id: offlinRecommendModelList
                    model: offlineModelListRecommendedFilter
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
