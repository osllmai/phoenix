import QtQuick 2.15
import QtQuick.Controls 2.15
// import Qt5Compat.GraphicalEffects
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
            width: parent.width - valueSliderBoxId.width
            height: parent.height
            Row{
                Text{
                    id:textId
                    text: root.myTextName
                    color: Style.Colors.textTitle
                    font.pointSize: 10
                }

                MyIcon{
                    id: aboutIcon
                    myIcon: aboutIcon.hovered? "qrc:/media/icon/aboutFill.svg": "qrc:/media/icon/about.svg"
                    myTextToolTip: root.myTextToolTip
                    width: 28; height: 28
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

                Text {
                    id: minValueSliderId
                    text: sliderId.from
                    color: Style.Colors.textTitle
                    anchors.left: parent.left
                    anchors.top: sliderId.bottom
                    anchors.leftMargin: 5
                    anchors.topMargin: 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 8
                }
                Text {
                    id: maxValueSliderId
                    text: sliderId.to
                    color: Style.Colors.textTitle
                    anchors.right: parent.right
                    anchors.top: sliderId.bottom
                    anchors.rightMargin: 5
                    anchors.topMargin: 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 8
                }
            }
        }
        Rectangle{
            id:valueSliderBoxId
            width: 50
            height: 30
            radius: 2
            color: Style.Colors.textTitle
            // anchors.verticalCenter: sliderId.verticalCenter
            // anchors.right: parent.right
            // anchors.rightMargin: 2
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

                validator: IntValidator{
                    bottom: root.sliderFrom
                    top: root.sliderTo
                }
            }
        }
    }
}
