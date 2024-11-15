cmake_minimum_required(VERSION 3.16)

set(PROJECTNAME  Phoenix)
project(${PROJECTNAME} VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 COMPONENTS Quick Sql REQUIRED)

qt_standard_project_setup()

qt_add_executable(app${PROJECTNAME}
    main.cpp
)

qt_add_qml_module(app${PROJECTNAME}
    URI ${PROJECTNAME}
    VERSION 1.0
    QML_FILES Main.qml
    QML_FILES ChatPage.qml
    QML_FILES ModelsPage.qml
    QML_FILES MyMenuItem.qml
    QML_FILES MyChatItem.qml
    QML_FILES MyIcon.qml
    QML_FILES SettingsDialog.qml
    QML_FILES MyMenuSettings.qml
    QML_FILES HomePage.qml
    QML_FILES DashbordItem.qml
    QML_FILES MyButton.qml
    QML_FILES ModelItem.qml
    QML_FILES DownloadModelButton.qml
    RESOURCES
        "images/aboutIcon.svg"
        "images/chatIcon.svg"
        "images/darkIcon.svg"
        "images/deleteIcon.svg"
        "images/documentIcon.svg"
        "images/downloadIcon.svg"
        "images/editIcon.svg"
        "images/fillChatIcon.svg"
        "images/fillDeleteIcon.svg"
        "images/fillEditIcon.svg"
        "images/fillHomeIcon.svg"
        "images/fillModelIcon.svg"
        "images/fillSendIcon.svg"
        "images/fillSettingsIcon.svg"
        "images/fillStopIcon.svg"
        "images/helpIcon.svg"
        "images/homeIcon.svg"
        "images/lightIcon.svg"
        "images/modelIcon.svg"
        "images/chatAddIcon.svg"
        "images/Phoenix.svg"
        "images/searchIcon.svg"
        "images/sendIcon.svg"
        "images/sendMessageIcon.svg"
        "images/settingsIcon.svg"
        "images/stopIcon.svg"
        "images/userIcon.svg"
        "images/image1.svg"
        "images/image2.svg"
        "images/image3.svg"
        "images/image4.svg"
        "images/image5.svg"
        "images/image6.svg"
        "images/image7.svg"
        "images/image8.svg"
        "images/image9.svg"
        "images/image10.svg"
        "images/image11.svg"
        "images/image12.svg"
        "images/image13.svg"
        "images/image14.svg"
        "images/image15.svg"
        "images/image16.svg"
        "images/image17.svg"
        "images/image18.svg"
        "images/image19.svg"
        "images/image20.svg"
        "images/menuExpandIeftIcon.svg"
        "images/menuExpandRightIcon.svg"
        "images/settingsModelIcon.svg"
        "images/fillSettingsModelIcon.svg"
        "images/upIcon.svg"
        "images/fillUpIcon.svg"
        "images/downIcon.svg"
        "images/fillDownIcon.svg"
        "images/mistral-ai-icon.svg"
        "images./githubIcon.svg"
        "images/discordIcon.svg"
        "images/alignLeftIcon.svg"
        "images/fillAlignLeftIcon.svg"
        "images/alignRightIcon.svg"
        "images/fillAlignRightIcon.svg"
        "images/fillMoonIcon.svg"
        "images/fillSunIcon.svg"
        "images/moonIcon.svg"
        "images/sunIcon.svg"
        "images/regenerateIcon.svg"
        "images/fillRegenerateIcon.svg"
        "images/copyIcon.svg"
        "images/fillCopyIcon.svg"
        "images/rightIcon.svg"
        "images/leftIcon.svg"
        "fontFamily/DMSans-VariableFont.ttf"
        "./phoenix.db"
        "./models.json"
    RESOURCE_PREFIX /

    SOURCES chat.h chat.cpp
    SOURCES chatllm.h chatllm.cpp
    SOURCES chatmodel.h chatmodel.cpp
    SOURCES chatitem.h chatitem.cpp
    SOURCES chatlistmodel.h chatlistmodel.cpp
    SOURCES phoenixcontroller.h phoenixcontroller.cpp
    SOURCES download.h download.cpp
    SOURCES model.h model.cpp
    SOURCES modellist.h modellist.cpp
    SOURCES currentmodellist.h currentmodellist.cpp
    QML_FILES SettingsSliderItem.qml
    QML_FILES MySlider.qml
    QML_FILES SettingsSwitchItem.qml
    QML_FILES MySwitch.qml
    SOURCES database.h database.cpp
    QML_FILES Constants.qml
    QML_FILES ApplicationSettingsPage.qml
    QML_FILES MyComboBox.qml
    QML_FILES MyMenuButtonItem.qml
    QML_FILES MyPromptResponse.qml
    QML_FILES MyMessage.qml
    SOURCES message.h message.cpp
    QML_FILES ModelDialog.qml
    QML_FILES InputPromptBox.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(app${PROJECTNAME} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.app2-${PROJECTNAME}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(app${PROJECTNAME}
    PRIVATE
        Qt6::Quick
        Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS app${PROJECTNAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
