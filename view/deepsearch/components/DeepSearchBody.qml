import QtQuick 2.15
import QtQuick.Controls 2.15

Item {

    ListView {
        anchors.fill: parent
        model: arxivModel
        delegate: Rectangle {
            width: 700
            height: 180
            color: "#f0f0f0"
            radius: 8
            border.color: "#cccccc"
            border.width: 1
            anchors.margins: 5

            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                Text { text: title; font.bold: true; wrapMode: Text.WordWrap }
                Text { text: "Authors: " + authors; wrapMode: Text.WordWrap }
                Text { text: summary; wrapMode: Text.WordWrap; elide: Text.ElideRight }

                Row {
                    spacing: 10
                    Button { text: "PDF"; onClicked: Qt.openUrlExternally(pdf) }
                    Button { text: "Abstract"; onClicked: Qt.openUrlExternally(link) }
                }
            }
        }
    }
}
