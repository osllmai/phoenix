import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import '../component_library/style' as Style
import "../component_library/button"

ComboBox {
    id: comboBoxId
    height: 35
    width: 10
    font.pixelSize: 12

    Accessible.role: Accessible.ComboBox
    contentItem: MyProgress{
        id: downloading
        myText: window.isDesktopSize? "Downloading": ""
        myValue: offlineModelList.downloadProgress
        myIcon: downloading.hovered? "qrc:/media/icon/downloadFill.svg":"qrc:/media/icon/download.svg"
        textLenght: 75
        enabled: true
        onHoveredChanged: comboBoxId.popup.open()
        onClicked: comboBoxId.popup.open()
    }

    popup: Downloading{
        id: downloadingPupup
        x: downloading.x
        y: downloading.y - downloadingPupup.height - 10
        width: 270 + 20
        height: Math.min(((offlineModelList.numberDownload * 48)), 250) + 20
    }
    indicator: Image {}
    background: null
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
}
