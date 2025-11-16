import QtQuick
import QtQuick.Layouts
import "./home"
import "./model"
import "./chat"
import "./developer"
import "./sql"
import "./pdf"
import "./deepsearch"

StackLayout {
    id: page
    currentIndex: 0

    function setModelPages(page, filter) {
        if (modelsLoader.item) {
            modelsLoader.item.setModelPages(page, filter)
        }
    }

    Loader {
        id: homeLoader
        active: true
        visible: page.currentIndex === 0
        sourceComponent: HomeView { }
    }

    Loader {
        id: chatLoader
        active: page.currentIndex === 1 || item !== null
        visible: page.currentIndex === 1
        sourceComponent: ChatView { }
    }

    Loader {
        id: modelsLoader
        active: page.currentIndex === 2 || item !== null
        visible: page.currentIndex === 2
        sourceComponent: ModelsView { }
    }

    Loader {
        id: developerLoader
        active: page.currentIndex === 3 || item !== null
        visible: page.currentIndex === 3
        sourceComponent: DeveloperView { }
    }

    Loader {
        id: sqlLoader
        active: page.currentIndex === 4 || item !== null
        visible: page.currentIndex === 4
        sourceComponent: SQLView { }
    }

    Loader {
        id: pdfLoader
        active: page.currentIndex === 5 || item !== null
        visible: page.currentIndex === 5
        sourceComponent: DeepSearchView { }
    }
}
