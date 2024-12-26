pragma Singleton

import QtQuick

QtObject {
    property bool isDark: false

    // General Theme
    property color backgroundPage: isDark ? "#333333" : "#ffffff"
    property color background: isDark ? "#1f1f1f" : "#ebebeb"
    property color glow: isDark ? "#1f1f1f" : "#d7d7d7"
    property color box: isDark ? "#333333" : "#f5f5f5"
    property color header: isDark ? "#242424" : "#f5f5f5"
    property color normalButton: isDark ? "#333333" : "#f5f5f5"
    property color selectButton: isDark ? "#1f1f1f" : "#ffffff"
    property color hoverButton: isDark ? "#5f5f5f" : "#ffffff"
    property color fillIcon: isDark ? "#5b5fc7" : "#5b5fc7"
    property color menuIcon: isDark ? "#ffffff" : "#747474"
    property color icon: isDark ? "#ffffff" : "#5b5fc7"

    property color titleText: isDark ? "#cbcdff" : "#000000"
    property color informationText: isDark ? "#ffffff" : "#474747"
    property color selectText: isDark ? "#000000" : "#000000"

    // Chat Page Theme
    property color chatBackground: isDark ? "#242424" : "#f5f5f5"
    property color chatBackgroundConversation: isDark ? "#333333" : "#ffffff"
    property color chatMessageBackground: isDark ? "#333333" : "#ebebeb"
    property color chatMessageTitleText: isDark ? "#cbcdff" : "#474747"
    property color chatMessageInformationText: isDark ? "#ffffff" : "#000000"
    property bool chatMessageIsGlow: isDark ? true : false
}
