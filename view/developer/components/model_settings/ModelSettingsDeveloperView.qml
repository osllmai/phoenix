import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import "../../../component_library/model_settings"

Item {
    height: parent.height - headerId.height
    width: parent.width
    ModelSettingsView{
        id: modelSettingsId
    }
}
