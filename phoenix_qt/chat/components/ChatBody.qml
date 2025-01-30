import QtQuick 2.15
import "./chat"
import '../../component_library/style' as Style

Item {
    id: controlId
    width: Math.min(752, parent.width - 48)
    anchors.horizontalCenter: parent.horizontalCenter

    Column{
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter
        Text{
            id: phoenixId
            text: "Hello! I’m Phoenix."
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.Colors.textTitle
            font.pixelSize: 18
            font.styleName: "Bold"
        }
        Text{
            id: informationText
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ask me anything! You can trust that our conversations are private, and your data is never shared for marketing."
            color: Style.Colors.textInformation
            font.pixelSize: 12
        }
        InputPrompt{
            id:inputBoxId
        }
    }
}
