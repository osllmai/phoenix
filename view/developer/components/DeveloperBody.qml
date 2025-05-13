import QtQuick 2.15
import "./command_line"
import "./model"
import "../../chat/components/model_settings"

Row{
    Column{
        Row{
            ModelDeveloper{

            }
        }
        CommandLineInterface{

        }
    }
    Item {

        width: 320
        height: parent.height
        Column{
            anchors.fill: parent
            anchors.margins: 16
            ModelSettingsHeader{
                id: headerId
                Connections{
                    target: headerId
                    function onCloseDrawer(){
                        drawerId.close()
                    }
                }
            }
            ModelSettingsBody{
                id: historyBadyId
            }
        }
    }
}

