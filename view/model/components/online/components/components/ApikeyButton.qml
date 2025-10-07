import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Item {
    id: control
    property bool isFillWidthDownloadButton: true

    property bool check: false
    property string modelId: ""
    property string modelName: ""
    property string modelIcon: ""
    property string modelSystemPrompt: ""
    property string modelKey: ""
    property bool installModel: false

    height: 35
    width: control.isFillWidthDownloadButton ? parent.width : 200

    // InputApikey (Fill Width)
    Loader {
        id: inputApikeyFillLoader
        active: isFillWidthDownloadButton /*&& !installModel*/
        sourceComponent: InputApikey {
            id: inputApikeyFill
            width: control.width
            modelKey: control.modelKey
            installModel: control.installModel
            check: control.check
            Connections {
                target: inputApikeyFill
                function onSaveAPIKey(apiKey) {
                    onlineCompanyList.saveAPIKey(modelId, apiKey)
                }
            }
        }
    }

    // InputApikey (Fixed Width)
    Loader {
        id: inputApikeyLoader
        active: !isFillWidthDownloadButton /*&& !installModel*/
        sourceComponent: InputApikey {
            id: inputApikey
            width: control.width
            modelKey: control.modelKey
            installModel: control.installModel
            check: control.check
            Connections {
                target: inputApikey
                function onSaveAPIKey(apiKey) {
                    onlineCompanyList.saveAPIKey(modelId, apiKey)
                }
            }
        }
    }
}
