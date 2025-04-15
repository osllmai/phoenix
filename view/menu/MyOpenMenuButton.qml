import QtQuick 2.15
import '../component_library/style' as Style
import '../component_library/button'

MyIcon{
    id: iconId
    width: 30; height: 30
    myIcon: iconId.myIcon()
    myTextToolTip: window.isOpenMenu?"Close": "Open"
    myWidthToolTip: 50
    toolTipInCenter: true
    iconType: Style.RoleEnum.IconType.Primary
    onClicked: { window.isOpenMenu = !window.isOpenMenu; }
    function myIcon(){
        if(window.isOpenMenu)
            if(!iconId.hovered)
                return appMenuDesktopId.visible? "qrc:/media/icon/alignLeft.svg": "qrc:/media/icon/alignRight.svg"
            else
                return appMenuDesktopId.visible? "qrc:/media/icon/alignLeftFill.svg": "qrc:/media/icon/alignRight.svg"
        else
            if(!iconId.hovered)
                return "qrc:/media/icon/alignRight.svg"
            else
                return "qrc:/media/icon/alignRightFill.svg"
    }
}
