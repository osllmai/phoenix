import QtQuick 2.15
import QtQuick.Controls
import QtWebView
import QtQuick.Layouts

Item {
    id: root
    width: 800
    height: 600

    // -------------------- TOOL BAR --------------------
    ToolBar {
        id: navigationBar
        height: 48
        width: parent.width
        anchors.top: parent.top

        RowLayout {
            anchors.fill: parent
            spacing: 6

            ToolButton {
                id: backButton
                icon.source: "qrc:/left-32.png"
                onClicked: webView.goBack()
                enabled: webView.canGoBack
                Layout.preferredWidth: 48
            }

            ToolButton {
                id: forwardButton
                icon.source: "qrc:/right-32.png"
                onClicked: webView.goForward()
                enabled: webView.canGoForward
                Layout.preferredWidth: 48
            }

            ToolButton {
                id: reloadButton
                icon.source: webView.loading ? "qrc:/stop-32.png" : "qrc:/refresh-32.png"
                onClicked: webView.loading ? webView.stop() : webView.reload()
                Layout.preferredWidth: 48
            }

            Item { Layout.preferredWidth: 5 }

            TextField {
                id: urlField
                Layout.fillWidth: true
                height: 36
                text: webView.url
                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhPreferLowercase
                onAccepted: webView.url = utils.fromUserInput(text)
            }

            ToolButton {
                id: goButton
                text: qsTr("Go")
                onClicked: {
                    Qt.inputMethod.commit()
                    Qt.inputMethod.hide()
                    webView.url = utils.fromUserInput(urlField.text)
                }
                Layout.preferredWidth: 48
            }

            ToolButton {
                id: settingsButton
                icon.source: "qrc:/settings-32.png"
                onClicked: {
                    settingsDrawer.width = (settingsDrawer.width > 0) ? 0 : root.width * 0.3
                }
                Layout.preferredWidth: 48
            }
        }

        ProgressBar {
            id: progress
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.bottom
            height: 3
            background: Rectangle { color: "transparent" }
            from: 0
            to: 100
            visible: true
            value: webView.loadProgress < 100 ? webView.loadProgress : 0
        }
    }

    // -------------------- SETTINGS DRAWER --------------------
    Item {
        id: settingsDrawer
        width: 0
        height: parent.height
        anchors.top: navigationBar.bottom
        anchors.right: parent.right

        Rectangle {
            anchors.fill: parent
            color: "#efefef"

            ColumnLayout {
                anchors.margins: 10
                anchors.fill: parent
                spacing: 10

                Label { text: "JavaScript" }
                CheckBox {
                    id: javaScriptEnabledCheckBox
                    text: "enabled"
                    onCheckStateChanged: webView.settings.javaScriptEnabled = (checkState == Qt.Checked)
                }

                Label { text: "Local storage" }
                CheckBox {
                    id: localStorageEnabledCheckBox
                    text: "enabled"
                    onCheckStateChanged: webView.settings.localStorageEnabled = (checkState == Qt.Checked)
                }

                Label { text: "Allow file access" }
                CheckBox {
                    id: allowFileAccessEnabledCheckBox
                    text: "enabled"
                    onCheckStateChanged: webView.settings.allowFileAccess = (checkState == Qt.Checked)
                }

                Label { text: "Local content can access file URLs" }
                CheckBox {
                    id: localContentCanAccessFileUrlsEnabledCheckBox
                    text: "enabled"
                    onCheckStateChanged: webView.settings.localContentCanAccessFileUrls = (checkState == Qt.Checked)
                }
            }
        }
    }

    // -------------------- WEB VIEW --------------------
    WebView {
        id: webView
        anchors.top: navigationBar.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: settingsDrawer.left

        url: initialUrl

        onLoadingChanged: function(loadRequest) {
            if (loadRequest.errorString)
                console.error(loadRequest.errorString)
        }

        Component.onCompleted: {
            javaScriptEnabledCheckBox.checkState = settings.javaScriptEnabled ? Qt.Checked : Qt.Unchecked
            localStorageEnabledCheckBox.checkState = settings.localStorageEnabled ? Qt.Checked : Qt.Unchecked
            allowFileAccessEnabledCheckBox.checkState = settings.allowFileAccess ? Qt.Checked : Qt.Unchecked
            localContentCanAccessFileUrlsEnabledCheckBox.checkState = settings.localContentCanAccessFileUrls ? Qt.Checked : Qt.Unchecked
        }
    }
}
