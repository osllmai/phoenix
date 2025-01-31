cmake_minimum_required(VERSION 3.16)

project(phoenix_0013 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appphoenix_0013
    main.cpp
)

qt_policy(SET QTP0004 NEW)

qt_add_qml_module(appphoenix_0013
    URI phoenix_0013
    VERSION 1.0
    QML_FILES
        Main.qml
        component_library/style/Colors.qml
        component_library/style/RoleEnum.qml
        component_library/button/MyButton.qml
        component_library/button/MyIcon.qml
        component_library/button/SearchButton.qml
        component_library/button/MySlider.qml
        component_library/button/MySwitch.qml

        AppMenuDesktop.qml
        AppMenuAplication.qml
        menu/MyMenuItem.qml

        AppBody.qml

        home/HomeView.qml
        home/components/HomeHeader.qml
        home/components/FeatureList.qml
        home/components/FeatureDelegate.qml

        model/ModelsView.qml
        model/components/ModelHeader.qml
        model/components/ModelBody.qml
        model/components/ModelMenu.qml
        model/components/offline/OfflineModelView.qml
        model/components/offline/OfflineHeader.qml
        model/components/offline/OfflineList.qml
        model/components/offline/OfflineDelegate.qml
        model/components/offline/DownloadButton.qml
        model/components/online/OnlineModelView.qml
        model/components/online/OnlineHeader.qml
        model/components/online/OnlineLine.qml
        model/components/online/OnlineDelegate.qml

        chat/ChatView.qml
        chat/components/ChatHeader.qml
        chat/components/HistoryDrawer.qml
        chat/components/ModelSettingsDrawer.qml
        chat/components/ChatBody.qml
        chat/components/chat/InputPrompt.qml
        chat/components/chat/ModelDialogButton.qml
        chat/components/chat/ModelDialog.qml
        chat/components/chat/ModelInformationPopup.qml
        chat/components/chat/ModelCompanyMenu.qml
        chat/components/chat/ModelItem.qml
        chat/components/history/HistoryHeader.qml
        chat/components/history/HistoryBody.qml
        chat/components/history/HistoryList.qml
        chat/components/history/HistoryDelegate.qml
        chat/components/model_settings/ModelSettingsHeader.qml
        chat/components/model_settings/ModelSettingsBody.qml
        chat/components/model_settings/MyMenuSettings.qml
        chat/components/model_settings/AssistantSettingsView.qml
        chat/components/model_settings/ModelSettingsView.qml
        chat/components/model_settings/components/ModelSettingsSlider.qml
        chat/components/model_settings/components/ModelSettingsSwitch.qml
        chat/components/model_settings/components/ModelInferencesSettings.qml
        chat/components/model_settings/components/ModelInformationSettings.qml
        chat/components/model_settings/components/ModelEngineSettings.qml
        chat/components/model_settings/components/ModelMenuSettings.qml


    RESOURCES
        component_library/style/qmldir
        "media/icon/add.svg"
        "media/icon/alignLeftFill.svg"
        "media/icon/alignLeft.svg"
        "media/icon/alignRightFill.svg"
        "media/icon/alignRight.svg"
        "media/icon/chatFill.svg"
        "media/icon/chat.svg"
        "media/icon/homeFill.svg"
        "media/icon/home.svg"
        "media/icon/indoxGen.svg"
        "media/icon/inDox.svg"
        "media/icon/indoxJudge.svg"
        "media/icon/modelFill.svg"
        "media/icon/model.svg"
        "media/icon/offline.svg"
        "media/icon/online.svg"
        "media/icon/phoenixCli.svg"
        "media/icon/phoenix.svg"
        "media/icon/like.svg"
        "media/icon/disLike.svg"
        "media/icon/history.svg"
        "media/icon/settings.svg"
        "media/icon/send.svg"
        "media/icon/sendFill.svg"
        "media/icon/stop.svg"
        "media/icon/stopFill.svg"
        "media/icon/search.svg"
        "media/icon/close.svg"
        "media/icon/pin.svg"
        "media/icon/pinFill.svg"
        "media/icon/delete.svg"
        "media/icon/deleteFill.svg"
        "media/icon/edit.svg"
        "media/icon/editFill.svg"
        "media/icon/ok.svg"
        "media/icon/okFill.svg"
        "media/icon/up.svg"
        "media/icon/upFill.svg"
        "media/icon/down.svg"
        "media/icon/downFill.svg"

    RESOURCE_PREFIX /
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appphoenix_0013 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appphoenix_0013
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appphoenix_0013
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appphoenix_0013
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
