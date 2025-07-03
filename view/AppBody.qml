import QtQuick.Layouts
import "./home"
import "./model"
import "./chat"
import "./developer"

StackLayout {
    id: page
    currentIndex: 0

    function setModelPages(page, filter){
        modelsPage.setModelPages(page, filter)
    }

    HomeView{id: homeViewId}

    ChatView{id: chatPage}

    ModelsView{id: modelsPage}

    DeveloperView{id: devloperPage}

}
