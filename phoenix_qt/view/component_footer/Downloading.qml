import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import '../component_library/style' as Style
import '../component_library/button'

T.Popup {
    id: systemMonitorPupup
    width: 270
    implicitHeight: (offlineModelListIsDownloadingFilter.count * 30) + 20

    background: Rectangle{
        id:systemMonitorRec
        anchors.fill: parent
        color: Style.Colors.boxNormalGradient0
        radius: 4
        border.color: Style.Colors.boxBorder
        border.width: 1

        ListView{
            id: companyList
            width: parent.width
            height: contentHeight
            anchors.centerIn: parent

            layoutDirection: Qt.RightToLeft
            snapMode: ListView.SnapToItem

            interactive: contentWidth > width
            boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

            model: offlineModelListIsDownloadingFilter
            delegate: MyProgress{
                myText: model.name
                myValue: model.downloadPercent
                myIcon: "qrc:/media/image_company/" + model.icon
                iconType: Style.RoleEnum.IconType.Image
                textLenght: 65
            }
        }

        layer.enabled: true
        layer.effect: Glow {
            samples: 40
            color:  Style.Colors.boxBorder
            spread: 0.1
            transparentBorder: true
         }
    }
}
