import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Item {
    id: control
    property bool isFillWidthDownloadButton: true


    height: 35
    width: control.isFillWidthDownloadButton ? parent.width : 400

    // InputApikey (Fill Width)
    Loader {
        id: inputApikeyFillLoader
        active: isFillWidthDownloadButton /*&& !installProvider*/
        sourceComponent: InputApikey {
            id: inputApikeyFill
            width: control.width
            Connections {
                target: inputApikeyFill
                function onSaveAPIKey(apiKey) {
                    onlineCompanyList.saveAPIKey(onlineBodyId.providerId, apiKey)
                }
            }
        }
    }

    // InputApikey (Fixed Width)
    Loader {
        id: inputApikeyLoader
        active: !isFillWidthDownloadButton /*&& !installProvider*/
        sourceComponent: InputApikey {
            id: inputApikey
            width: control.width
            Connections {
                target: inputApikey
                function onSaveAPIKey(apiKey) {
                    onlineCompanyList.saveAPIKey(onlineBodyId.providerId, apiKey)
                }
            }
        }
    }
}
