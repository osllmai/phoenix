import QtQuick 2.15
import QtQuick.Layouts
import "./offline"
import "./online"
import "./huggingface"

StackLayout {
    id: page
    currentIndex: 0

    function setFilter(pageName, filter){
        if(pageName === "offline" && offlineLoader.item)
            offlineLoader.item.setFilter(filter)
        else if(pageName === "online" && onlineLoader.item)
            onlineLoader.item.setFilter(filter)
        else if(pageName === "huggingface" && huggingfaceLoader.item)
            huggingfaceLoader.item.setFilter(filter)
    }

    Loader {
        id: offlineLoader
        active: page.currentIndex === 0 || item !== null
        visible: page.currentIndex === 0
        sourceComponent: OfflineModelView { id: offlineModel }
    }

    Loader {
        id: onlineLoader
        active: page.currentIndex === 1 || item !== null
        visible: page.currentIndex === 1
        sourceComponent: OnlineModelView { id: onlineModel }
    }

    Loader {
        id: huggingfaceLoader
        active: page.currentIndex === 2 || item !== null
        visible: page.currentIndex === 2
        sourceComponent: HuggingfaceModelView { id: huggingfaceModel }
    }
}

// import QtQuick 2.15
// import QtQuick.Controls 2.15
// import QtQuick.Layouts
// import "./offline"
// import "./online"
// import "./huggingface"

// StackLayout {
//     id: page
//     currentIndex: 0

//     function setFilter(pageName, filter){
//         if (pageName === "offline" && offlineLoader.item)
//             offlineLoader.item.setFilter(filter)
//         else if (pageName === "online" && onlineLoader.item)
//             onlineLoader.item.setFilter(filter)
//         else if (pageName === "huggingface" && huggingfaceLoader.item)
//             huggingfaceLoader.item.setFilter(filter)
//     }

//     // ---------- OFFLINE PAGE ----------
//     Item {
//         anchors.fill: parent

//         Loader {
//             id: offlineLoader
//             anchors.fill: parent
//             active: page.currentIndex === 0 || item !== null
//             visible: page.currentIndex === 0
//             asynchronous: true
//             sourceComponent: OfflineModelView { id: offlineModel }
//         }

//         // load skeleton via Loader (instantiate the Component)
//         Loader {
//             id: offlineSkeletonLoader
//             anchors.fill: parent
//             asynchronous: true
//             active: offlineLoader.status === Loader.Loading
//             visible: offlineLoader.status === Loader.Loading
//             sourceComponent: /*skeletonComponent*/    Rectangle {
//                 anchors.fill: parent
//                 color: "#f5f5f5"
//                 z: 999
//                 MouseArea { anchors.fill: parent; enabled: true }

//                 Column {
//                     anchors.centerIn: parent
//                     spacing: 12

//                     BusyIndicator {
//                         running: true
//                         width: 48; height: 48
//                     }

//                     Text {
//                         text: "Loading..."
//                         color: "#666"
//                     }
//                 }
//             }
//             z: 999
//         }
//     }

//     // ---------- ONLINE PAGE ----------
//     Item {
//         anchors.fill: parent

//         Loader {
//             id: onlineLoader
//             anchors.fill: parent
//             active: page.currentIndex === 1 || item !== null
//             visible: page.currentIndex === 1
//             asynchronous: true
//             sourceComponent: OnlineModelView { id: onlineModel }
//         }

//         Loader {
//             id: onlineSkeletonLoader
//             anchors.fill: parent
//             asynchronous: true
//             active: onlineLoader.status === Loader.Loading
//             visible: onlineLoader.status === Loader.Loading
//             sourceComponent: /*skeletonComponent*/    Rectangle {
//                 anchors.fill: parent
//                 color: "#f5f5f5"
//                 z: 999
//                 MouseArea { anchors.fill: parent; enabled: true }

//                 Column {
//                     anchors.centerIn: parent
//                     spacing: 12

//                     BusyIndicator {
//                         running: true
//                         width: 48; height: 48
//                     }

//                     Text {
//                         text: "Loading..."
//                         color: "#666"
//                     }
//                 }
//             }
//             z: 999
//         }
//     }

//     // ---------- HUGGINGFACE PAGE ----------
//     Item {
//         anchors.fill: parent

//         Loader {
//             id: huggingfaceLoader
//             anchors.fill: parent
//             active: page.currentIndex === 2 || item !== null
//             visible: page.currentIndex === 2
//             asynchronous: true
//             sourceComponent: HuggingfaceModelView { id: huggingfaceModel }
//         }

//         Loader {
//             id: huggingfaceSkeletonLoader
//             anchors.fill: parent
//             asynchronous: true
//             active: huggingfaceLoader.status === Loader.Loading
//             visible: huggingfaceLoader.status === Loader.Loading
//             sourceComponent: /*skeletonComponent*/    Rectangle {
//                 anchors.fill: parent
//                 color: "#f5f5f5"
//                 z: 999
//                 MouseArea { anchors.fill: parent; enabled: true }

//                 Column {
//                     anchors.centerIn: parent
//                     spacing: 12

//                     BusyIndicator {
//                         running: true
//                         width: 48; height: 48
//                     }

//                     Text {
//                         text: "Loading..."
//                         color: "#666"
//                     }
//                 }
//             }
//             z: 999
//         }
//     }
// }
