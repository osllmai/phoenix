import QtQuick 2.15
import QtQuick.Controls 2.15
// import Qt5Compat.GraphicalEffects
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item {
    id: root
    height: 60; width: parent.width

    property alias myTextName: textId.text
    // property alias myTextDescription: aboutIcon.myLable
    property double sliderValue: 0.5
    property double sliderFrom: -1
    property double sliderTo: 3
    property double sliderStepSize: 0.1
    property int decimalPart: 0

    Rectangle{
        id: settingsSliderBox
        anchors.fill: parent
        color: "#00ffffff"
        Text{
            id:textId
            text: "Temperature"
            color: Style.Colors.textTitle
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.topMargin: 0
            font.pointSize: 10
        }

        Item{
            id: closeBox
            width: 30; height: 30
            ToolButton {
                id: searchIcon
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width:searchIcon.hovered? 30: 28; height: searchIcon.hovered? 30: 28
                Behavior on width{ NumberAnimation{ duration: 150}}
                Behavior on height{ NumberAnimation{ duration: 150}}
                background: null
                icon{
                    source: "qrc:/media/icon/close.svg"
                    color: searchIcon.hovered? Style.Colors.iconHoverAndChecked: Style.Colors.iconNormal
                    width: searchIcon.width; height: searchIcon.height
                }
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked:{}
                }
            }
        }

        // MyIcon {
        //     id: aboutIcon
        //     visible: true
        //     anchors.verticalCenter: textId.verticalCenter
        //     anchors.left: textId.right
        //     anchors.leftMargin: 5
        //     width: 20
        //     height: 20
        //     myIconId: "images/aboutIcon.svg"
        //     myFillIconId: "images/fillAboutIcon.svg"
        //     myLable: "Discord"
        //     heightSource: 15
        //     widthSource: 15
        //     normalColor: Style.Theme.iconColor
        //     hoverColor: Style.Theme.fillIconColor
        //     xPopup: -18
        //     yPopup: -30
        //     Connections {
        //         target: aboutIcon
        //         function onActionClicked() {}
        //     }
        // }

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
            color: Style.Colors.textTitle
            anchors.verticalCenter: sliderId.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 2
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
            // layer.enabled: true
            // layer.effect: Glow {
            //      samples: 15
            //      color: Style.Colors.textTitle
            //      spread: 0.0
            //      transparentBorder: true
            //  }
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
            anchors.right: valueSliderBoxId.left
            anchors.top: sliderId.bottom
            anchors.rightMargin: 5
            anchors.topMargin: 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 8
        }
    }
}
