import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item {
    id: root
    height: 60; width: parent.width

    property string myTextName: ""
    property string myTextToolTip: ""
    property double sliderValue: 0.5
    property double sliderFrom: -1
    property double sliderTo: 3
    property double sliderStepSize: 0.1
    property int decimalPart: 0

    Row{
        anchors.fill: parent
        Column{
            id: sliderColumnId
            width: parent.width - valueSliderBoxId.width

            Row{
                height: 22
                anchors.left: parent.left
                anchors.leftMargin: 5
                Label {
                    id:textId
                    text: root.myTextName
                    color: Style.Colors.textTitle
                    font.pointSize: 10
                }

                MyIcon{
                    id: aboutIcon
                    width: 28; height: 28
                    myIcon: aboutIcon.hovered? "qrc:/media/icon/aboutFill.svg": "qrc:/media/icon/about.svg"
                    myTextToolTip: root.myTextToolTip
                    anchors.verticalCenter: textId.verticalCenter
                }
            }
            Item{
                id: settingsSliderBox
                width: parent.width
                height: 30

                MySlider{
                    id:sliderId
                    width: parent.width
                    value: root.sliderValue
                    from: root.sliderFrom
                    to: root.sliderTo
                    stepSize: root.sliderStepSize
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
        Rectangle{
            id:valueSliderBoxId
            color: Style.Colors.background
            border.color: Style.Colors.boxBorder
            anchors.verticalCenter: sliderColumnId.verticalCenter
            width: 50; height: 30
            radius: 8
            TextField {
                id: valueSlider1Id
                visible: root.sliderStepSize<1
                text: sliderId.value.toFixed(root.decimalPart)
                color: Style.Colors.textTitle
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                background: null

                validator: DoubleValidator {
                    bottom: root.sliderFrom
                    top: root.sliderTo
                    decimals: root.decimalPart
                }
            }
            TextField {
                id: valueSlider2Id
                visible: root.sliderStepSize>=1
                text: sliderId.value.toFixed(root.decimalPart)
                color: Style.Colors.textTitle
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                inputMethodHints: Qt.ImhDigitsOnly
                background: null

                validator: IntValidator{
                    bottom: root.sliderFrom
                    top: root.sliderTo
                }
            }
        }
    }
}
