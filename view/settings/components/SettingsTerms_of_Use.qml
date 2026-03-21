import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style

Item {
    id: controlId
    clip: true

    property string htmlContent: ""

    Component.onCompleted: {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "terms_of_use_content.html")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                htmlContent = xhr.responseText.replace(/\{\{LINK_COLOR\}\}/g, Style.Colors.textInformation)
            }
        }
        xhr.send()
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 15
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip: true

        contentWidth: scrollView.width

        Label {
            id: labelId
            width: scrollView.width - 15
            textFormat: Text.RichText
            wrapMode: Text.Wrap
            font.pixelSize: 14
            color: Style.Colors.textInformation
            horizontalAlignment: Text.AlignJustify
            anchors.margins: 10

            text: controlId.htmlContent

            onLinkActivated: function(link) {
                Qt.openUrlExternally(link)
            }

            height: implicitHeight

            Accessible.role: Accessible.Button
            Accessible.name: text
            Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
        }
    }
}
