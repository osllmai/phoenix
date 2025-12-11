import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item{
    id:control
    height: 40; width: parent.width
    clip:true

    property int currentPageNumber: 0

    signal currentPage(int numberPage)

    RowLayout {
        id: rowMethodId
        height: 35
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: ListModel {
                ListElement { name: "Activity"; pageNumber: 0 }
                ListElement { name: "Source"; pageNumber: 1 }
            }

            delegate: MyMenu {
                id: delegateId
                myText: model.name
                autoExclusive: true
                checked: control.currentPageNumber === model.pageNumber

                onClicked: {
                    control.currentPageNumber = model.pageNumber
                    control.currentPage(model.pageNumber)
                }

                Component.onCompleted: {
                    if (index === 0) {
                        checked = true
                        control.currentPageNumber = model.pageNumber
                        control.currentPage(model.pageNumber)
                    }
                }
            }
        }
    }

    MyIcon{
        id: closeBox
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: 25; height: 25
        myIcon: "qrc:/media/icon/close.svg"
        myTextToolTip: "Close"
        onClicked:{conversationList.currentConversation.isOpenMessage = false}
    }
}
