import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item {
    id: control
    width: parent.width
    height: parent.height - inputBoxId.height - 20
    clip: true

    function goToEnd(){
        listView.positionViewAtEnd();
    }

    ListView {
        id: listView
        anchors.fill: parent
        cacheBuffer: Math.max(0, listView.contentHeight)

        interactive: contentHeight > height
        boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        flickDeceleration: 200
        maximumFlickVelocity: 12000

        ScrollBar.vertical: ScrollBar {
            policy: listView.contentHeight > listView.height
                    ? ScrollBar.AlwaysOn
                    : ScrollBar.AlwaysOff
        }
        clip: true

        model: conversationList.currentConversation ? conversationList.currentConversation.messageList : []

        delegate: Item{
            width: parent.width
            height: loader.height

            Loader {
                  id: loader
                  width: Math.min(670, listView.width - 48)
                  anchors.horizontalCenter: parent.horizontalCenter
                  sourceComponent: model.isDeepSearch ? deepSearchDelegate : messageDelegate

                  Component {
                      id: messageDelegate
                      MessageDelegate { }
                  }

                  Component {
                      id: deepSearchDelegate
                      DeepSearchMessageDelegate { }
                  }
            }
        }

        onContentHeightChanged: {
            if (listView.atYEnd) {
                listView.positionViewAtEnd();
            }
        }
    }

    MyButton{
        id: goBottonId
        visible:  (listView.contentHeight > listView.height) && (!listView.atYEnd)
        width: 35; height: 35
        myIcon: "qrc:/media/icon/down.svg"
        myRadius: 50
        bottonType: Style.RoleEnum.BottonType.Secondary
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        Connections {
            target: goBottonId
            function onClicked(){listView.positionViewAtEnd();}
        }
    }
}
