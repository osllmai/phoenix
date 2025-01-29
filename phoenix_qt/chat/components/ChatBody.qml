import QtQuick 2.15
import "./chat"
import '../../component_library/style' as Style

Item {
    id: controlId
    width: Math.min(752, parent.width - 48)
    anchors.horizontalCenter: parent.horizontalCenter

    Column{
        spacing: 24
        anchors.verticalCenter: parent.verticalCenter
        Text{
            id: inDoxId
            text: "Hello! I’m InDox."
            color: Style.Colors.textTitle
            font.pixelSize: 20
            font.styleName: "Bold"
        }
        Text{
            id: informationText
            text: "Ask me anything! You can trust that our conversations are private, and your data is never shared for marketing."
            color: Style.Colors.textInformation
            font.pixelSize: 16
        }
        InputPrompt{
            id:inputBoxId

        }
    }
}
