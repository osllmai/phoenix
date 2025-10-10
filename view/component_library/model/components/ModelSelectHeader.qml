import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../style' as Style
import '../../button'

Item{
    id:control
    height: 40; width: parent.width
    clip:true

    property bool needCloseButton: true
    property int currentPageNumber: 0

    signal search(var text)
    signal currentPage(int numberPage)

    RowLayout {
        id: rowMethodId
        height: 35
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: ListModel {
                id: model
                ListElement {
                        name: "Local";
                        icon: "qrc:/media/icon/offline.svg";
                        pageNumber: 0
                }
                ListElement {
                        name: "Online";
                        icon: "qrc:/media/icon/online.svg";
                        pageNumber: 1
                }
            }

            delegate: MyMenu {
                id: delegateId
                myIcon: model.icon
                myText: model.name
                autoExclusive: false
                checked: control.currentPageNumber === model.pageNumber
                onClicked: {
                    control.currentPageNumber = model.pageNumber;
                    control.currentPage(model.pageNumber);
                }
            }
        }
    }

    MyIcon{
        id: closeBox
        visible: control.needCloseButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: 25; height: 25
        myIcon: "qrc:/media/icon/close.svg"
        myTextToolTip: "Close"
        onClicked:{comboBoxId.popup.close()}
    }
}
