import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width: 250
    height: 60

    property var fontFamily
    property color textColor: "black"
    property color boxColor: "#e0dede"
    property color glowColor

    property alias myTextName: textId.text
    property double sliderValue: 0.5
    property double sliderFrom: -1
    property double sliderTo: 3
    property double sliderStepSize: 0.1

    Rectangle{
        id: settingsSliderBox
        anchors.fill: parent
        color: "#00ffffff"
        Text{
            id:textId
            text: "Temperature"
            color: root.textColor
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.topMargin: 0
            font.pointSize: 10
            font.family: root.fontFamily
        }

        MyIcon {
            id: discordIcon
            visible: true
            anchors.verticalCenter: textId.verticalCenter
            anchors.left: textId.right
            anchors.leftMargin: 5
            width: 20
            height: 20
            myIconId: "images/aboutIcon.svg"
            myFillIconId: "images/fillAboutIcon.svg"
            myLable: "Discord"
            heightSource: 15
            widthSource: 15
            normalColor: "#5b5fc7"
            hoverColor: "#5b5fc7"
            xPopup: -18
            yPopup: -30
            Connections {
                target: discordIcon
                function onActionClicked() {}
            }
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
            color: root.boxColor
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
            layer.enabled: true
            layer.effect: Glow {
                 samples: 15
                 color: root.glowColor
                 spread: 0.0
                 transparentBorder: true
             }
        }
        Text {
            id: minValueSliderId
            text: sliderId.from
            color: root.textColor
            anchors.left: parent.left
            anchors.top: sliderId.bottom
            anchors.leftMargin: 5
            anchors.topMargin: 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 8
            font.family: root.fontFamily
        }
        Text {
            id: maxValueSliderId
            text: sliderId.to
            color: root.textColor
            anchors.right: valueSliderBoxId.left
            anchors.top: sliderId.bottom
            anchors.rightMargin: 5
            anchors.topMargin: 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 8
            font.family: root.fontFamily
        }
    }


}
