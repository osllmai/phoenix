import QtQuick
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

MyButton {
    id: root
    property string filterValue: ""
    property string currentValue: ""
    property int featureIcon: Style.RoleEnum.IconType.FeatureBlue

    bottonType: Style.RoleEnum.BottonType.Feature
    iconType: featureIcon
    isNeedAnimation: true
    selected: currentValue === filterValue

    signal filterClicked(string value)

    MouseArea {
        anchors.fill: parent
        onClicked: root.filterClicked(root.filterValue)
    }
}
