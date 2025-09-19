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
                        name: "Offline Model";
                        pageNumber: 0
                }
                ListElement {
                        name: "Online Model";
                        pageNumber: 1
                }
            }

            delegate: MyButton {
                id: delegateId
                myText: model.name
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureBlue
                isNeedAnimation: true
                checkable: true
                checked: control.currentPageNumber === model.pageNumber
                selected: control.currentPageNumber === model.pageNumber
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
