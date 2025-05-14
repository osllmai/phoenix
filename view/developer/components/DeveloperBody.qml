import QtQuick 2.15
import '../../component_library/style' as Style
import "./command_line"
import "./model"
import "curl"

Row{
    Column{
        width: parent.width - modelSettingSpaceId.width
        height: parent.height
        Row{
            width: parent.width
            height: parent.height  - commandLineInterfaceId.height
            ModelDeveloperView{
                id: modelDeveloperId
                width: parent.width - curlDeveloperId.width
                height: parent.height
            }
            CurlDeveloper{
                id: curlDeveloperId
                height: parent.height
                width: (2*parent.width)/3
            }
        }
        CommandLineInterface{
            id: commandLineInterfaceId
            height: parent.height/3
            width: parent.width
        }
    }

    ModelSettingsDeveloper{
        id: modelSettingSpaceId
        width: 320
        height: parent.height
    }
}

