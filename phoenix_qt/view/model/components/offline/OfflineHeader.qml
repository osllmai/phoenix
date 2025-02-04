import QtQuick 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item{
    id:headerId
    width: parent.width
    height: phoenixId.height + fillterBox.height  + 18
    clip:true
    signal search(var text)
    Column{
        id: columnId
        anchors.fill: parent
        anchors.leftMargin: 30
        spacing: 10
        Text {
            id: phoenixId
            text: qsTr("Offline Model")
            color: Style.Colors.textTitle
            font.pixelSize: 20
            font.styleName: "Bold"
        }

        Row{
            id: fillterBox
            width: parent.width
            SearchButton{
                id: searchBoxId
                Connections{
                    target: searchBoxId
                    function onSearch(mytext){
                        headerId.search(mytext)
                    }
                }
            }
            Item{
                width: parent.width
                Flow{
                    spacing: 5
                    anchors.right: parent.right; anchors.rightMargin: 40
                    MyButton {
                        id: documentId
                        myText: "Document"
                        myIcon: "qrc:/media/icon/settings.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureBlue
                        isNeedAnimation: true
                    }
                    MyButton {
                        id: grammarId
                        myText: "Grammer"
                        myIcon: "qrc:/media/icon/settings.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureRed
                        isNeedAnimation: true
                    }
                    MyButton {
                        id: rewriteId
                        myText: "Rewrite"
                        myIcon: "qrc:/media/icon/settings.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureOrange
                        isNeedAnimation: true
                    }
                    MyButton {
                        id: imageEditorId
                        myText: "Image Editor"
                        myIcon: "qrc:/media/icon/settings.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureGreen
                        isNeedAnimation: true
                    }
                    MyButton {
                        id: imageId
                        myText: "Image"
                        myIcon: "qrc:/media/icon/settings.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureYellow
                        isNeedAnimation: true
                    }
                }
            }
        }
    }
}
