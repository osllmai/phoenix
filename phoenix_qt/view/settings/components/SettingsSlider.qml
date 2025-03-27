import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style
import '../../component_library/button'

Item {
    id: root
    height: 35; width: parent.width

    property string myTextName: ""
    property string myTextToolTip: ""
    property double sliderValue: 0.5
    property double sliderFrom: -1
    property double sliderTo: 3
    property double sliderStepSize: 0.1
    property int decimalPart: 0

    Row{
        Label {
            id:textId
            text: root.myTextName
            width: 100
            color: Style.Colors.textTitle
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Item{
            id: settingsSliderBox
            width: 200
            height: 35

            MySlider{
                id:sliderId
                width: parent.width
                value: root.sliderValue
                from: root.sliderFrom
                to: root.sliderTo
                stepSize: root.sliderStepSize
                anchors.verticalCenter: parent.verticalCenter
                onValueChanged: root.sliderValue = value
            }

            Label {
                id: minValueSliderId
                text: sliderId.from
                color: Style.Colors.textTitle
                anchors.left: parent.left
                anchors.top: sliderId.bottom
                anchors.leftMargin: 10
                anchors.topMargin: 0
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 8
            }
            Label {
                id: maxValueSliderId
                text: sliderId.to
                color: Style.Colors.textTitle
                anchors.right: parent.right
                anchors.top: sliderId.bottom
                anchors.rightMargin: 10
                anchors.topMargin: 0
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 8
            }
        }
    }
}
