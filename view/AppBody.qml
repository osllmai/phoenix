import QtQuick.Layouts
import "./home"
import "./model"
import "./chat"
import "./developer"

StackLayout {
    id: page
    currentIndex: 0

    HomeView{id: homeViewId}

    ChatView{id: chatPage}

    ModelsView{id: modelsPage}

    DeveloperView{id: devloperPage}

}
