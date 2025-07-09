import QtQuick 2.15
import QtQuick.Controls 2.15
import '../style' as Style
import "../button"

Item{
    id: headerId
    height: 40; width: parent.width
    clip:true
    signal closeDrawer()
    Column{
        spacing: 8
        anchors.fill: parent
        Row{
            height: 35
            spacing: parent.width - titleId.width - closeBox.width
            Label {
                id: titleId
                text: qsTr("Model Settings")
                color: Style.Colors.textTitle
                font.pixelSize: 20
                font.styleName: "Bold"
            }

            MyIcon{
                id: closeBox
                visible: modelSettingsId.needCloseButton
                width: 30; height: 30
                myIcon: "qrc:/media/icon/close.svg"
                myTextToolTip: "Close"
                isNeedAnimation: true
                onClicked:{headerId.closeDrawer()}
            }
        }
    }
}
