import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import "../../../component_library/button"

Item {
    id: control
    clip: true

    Rectangle {
        id: instructionsBox
        anchors.fill: parent
        anchors.margins: 10
        radius: 12
        color: Style.Colors.boxHover
        border.color: "#444"
        border.width: 1

        Column{
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            Flickable {
                id: flickable
                width: parent.width
                height: parent.height - installButton.height - 8
                anchors.margins: 10
                // contentHeight: column.implicitHeight
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
                        visible: offlineFinishedDownloadModelList.height>30
                        text: "Available Models"
                        color: Style.Colors.textTitle
                        verticalAlignment: Text.AlignBottom
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                        clip: true
                    }

                    ModelDeveloperList {
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

                    ModelDeveloperList {
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
}
