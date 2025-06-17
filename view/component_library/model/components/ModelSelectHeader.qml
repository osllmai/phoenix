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
                onClicked: {
                    control.currentPageNumber = model.pageNumber;
                    control.currentPage(model.pageNumber);
                }
            }
        }
    }

    Item{
        id: closeBox
        visible: control.needCloseButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: 25; height: 25
        ToolButton {
            id: searchIcon
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width:searchIcon.hovered? 24: 23; height: searchIcon.hovered? 24: 23
            Behavior on width{ NumberAnimation{ duration: 150}}
            Behavior on height{ NumberAnimation{ duration: 150}}
            background: null
            icon{
                source: "qrc:/media/icon/close.svg"
                color: searchIcon.hovered? Style.Colors.iconPrimaryHoverAndChecked: Style.Colors.iconPrimaryNormal
                width: searchIcon.width; height: searchIcon.height
            }
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{comboBoxId.popup.close()}
            }
        }
    }
}
