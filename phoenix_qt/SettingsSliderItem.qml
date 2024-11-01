import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: 250
    height: 60

    Constants{
        id: constantsId
    }

    property var fontFamily: constantsId.fontFamily
    property color textColor: "black"
    property color borderColor: "#e0dede"

    property alias myTextName: textId.text
    property double sliderValue: 0.5
    property double sliderFrom: -1
    property double sliderTo: 3
    property double sliderStepSize: 0.1

    Rectangle{
        id: settingsSliderBox
        anchors.fill: parent
        Text{
            id:textId
            text: "Temperature"
            color: root.textColor
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.topMargin: 0
            font.pointSize: 10
            font.styleName: "Bold"
            font.family: root.fontFamily
        }

        MySlider{
            id:sliderId
            anchors.left: parent.left
            anchors.right: valueSliderBoxId.left
            anchors.top: textId.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 5
            anchors.topMargin: 10
            value: root.sliderValue
            from: root.sliderFrom
            to: root.sliderTo
            stepSize: root.sliderStepSize

        }
        Rectangle{
            id:valueSliderBoxId
            width: 40
            height: 30
            radius: 2
            border.color: root.borderColor
            anchors.verticalCenter: sliderId.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 2
            Text {
                id: valueSliderId
                text: sliderId.value
                color: root.textColor
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                font.family: root.fontFamily
            }
        }
        Text {
            id: minValueSliderId
            text: sliderId.from
            color: root.textColor
            anchors.left: parent.left
            anchors.top: sliderId.bottom
            anchors.leftMargin: 5
            anchors.topMargin: 5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 10
            font.family: root.fontFamily
        }
        Text {
            id: maxValueSliderId
            text: sliderId.to
            color: root.textColor
            anchors.right: valueSliderBoxId.left
            anchors.top: sliderId.bottom
            anchors.rightMargin: 5
            anchors.topMargin: 5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 10
            font.family: root.fontFamily
        }
    }


}
