cmake_minimum_required(VERSION 3.16)

set(APP_VERSION_MAJOR 0)
set(APP_VERSION_MINOR 0)
set(APP_VERSION_PATCH 15)
set(APP_VERSION_BASE "${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}.${APP_VERSION_PATCH}")
set(APP_VERSION "${APP_VERSION_BASE}-dev0")

set(PROJECT_NAME phoenix_15)
project(${PROJECT_NAME} VERSION ${APP_VERSION_BASE} LANGUAGES CXX C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_GENERATE_QMLLS_INI ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Core Concurrent Gui Qml Sql)

qt_standard_project_setup(REQUIRES 6.5)

include_directories(${CMAKE_SOURCE_DIR}/core)
include_directories(${CMAKE_SOURCE_DIR}/core/model/)
include_directories(${CMAKE_SOURCE_DIR}/core/model/offline)
include_directories(${CMAKE_SOURCE_DIR}/core/model/online)
include_directories(${CMAKE_SOURCE_DIR}/core/conversation)
include_directories(${CMAKE_SOURCE_DIR}/core/conversation/chat)
include_directories(${CMAKE_SOURCE_DIR}/core/conversation/provider)


# Include the binary directory for the generated header file
include_directories("${CMAKE_CURRENT_BINARY_DIR}")

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

qt_add_executable(app${PROJECT_NAME}
    core/main.cpp
    media/image_company/appIcon.rc

    core/database.h core/database.cpp
    core/systemmonitor.h core/systemmonitor.cpp

    core/model/BackendType.h
    core/model/model.h core/model/model.cpp
    core/model/company.h core/model/company.cpp
    core/model/companylist.h core/model/companylist.cpp
    core/model/companylistfilter.h core/model/companylistfilter.cpp

    core/model/offline/offlinemodel.h core/model/offline/offlinemodel.cpp
    core/model/offline/offlinemodellist.h core/model/offline/offlinemodellist.cpp
    core/model/offline/offlinemodellistfilter.h core/model/offline/offlinemodellistfilter.cpp
    core/model/offline/download.h core/model/offline/download.cpp

    core/model/online/onlinemodel.h core/model/online/onlinemodel.cpp
    core/model/online/onlinemodellist.h core/model/online/onlinemodellist.cpp
    core/model/online/onlinemodellistfilter.h core/model/online/onlinemodellistfilter.cpp

    core/conversation/conversation.h core/conversation/conversation.cpp
    core/conversation/conversationlist.h core/conversation/conversationlist.cpp
    core/conversation/conversationlistfilter.h core/conversation/conversationlistfilter.cpp
    core/conversation/chat/messagelist.h core/conversation/chat/messagelist.cpp
    core/conversation/chat/message.h core/conversation/chat/message.cpp
    core/conversation/chat/modelsettings.h core/conversation/chat/modelsettings.cpp
    core/conversation/chat/responselist.h core/conversation/chat/responselist.cpp
    core/conversation/provider/onlineprovider.h core/conversation/provider/onlineprovider.cpp
    core/conversation/provider/offlineprovider.h core/conversation/provider/offlineprovider.cpp
    core/conversation/provider/provider.h core/conversation/provider/provider.cpp
)

qt_add_resources(app${PROJECT_NAME}
    PREFIX /
    FILES
        media/icon/add.svg
        media/icon/alignLeftFill.svg
        media/icon/alignLeft.svg
        media/icon/alignRightFill.svg
        media/icon/alignRight.svg
        media/icon/chatFill.svg
        media/icon/chat.svg
        media/icon/homeFill.svg
        media/icon/home.svg
        media/icon/indoxGen.svg
        media/icon/inDox.svg
        media/icon/indoxJudge.svg
        media/icon/modelFill.svg
        media/icon/model.svg
        media/icon/offline.svg
        media/icon/online.svg
        media/icon/phoenixCli.svg
        media/icon/phoenix.svg
        media/icon/like.svg
        media/icon/disLike.svg
        media/icon/history.svg
        media/icon/settings.svg
        media/icon/send.svg
        media/icon/sendFill.svg
        media/icon/stop.svg
        media/icon/stopFill.svg
        media/icon/search.svg
        media/icon/close.svg
        media/icon/pin.svg
        media/icon/pinFill.svg
        media/icon/delete.svg
        media/icon/deleteFill.svg
        media/icon/edit.svg
        media/icon/editFill.svg
        media/icon/ok.svg
        media/icon/okFill.svg
        media/icon/up.svg
        media/icon/upFill.svg
        media/icon/down.svg
        media/icon/downFill.svg
        media/icon/download.svg
        media/icon/downloadFill.svg
        media/icon/systemMonitor.svg
        media/icon/discord.svg
        media/icon/github.svg
        media/icon/copy.svg
        media/icon/copyFill.svg
        media/icon/copySuccess.svg
        media/icon/copySuccessFill.svg
        media/icon/about.svg
        media/icon/aboutFill.svg
        media/icon/document.svg
        media/icon/grammer.svg
        media/icon/image.svg
        media/icon/imageEditor.svg
        media/icon/rewrite.svg
        media/image_company/user.svg

        media/image_company/Phoenix.png
        media/image_company/Bert.svg
        media/image_company/MetaLlama.svg
        media/image_company/Mistral.svg
        media/image_company/Databricks.svg
        media/image_company/Microsoft.svg
        media/image_company/Qwen.svg
        media/image_company/Replit.svg
        media/image_company/BigCode.png
        media/image_company/Openai.svg

        media/media.qrc
)

qt_policy(SET QTP0004 NEW)

qt_add_qml_module(app${PROJECT_NAME}
    URI ${PROJECT_NAME}
    VERSION 1.0
    QML_FILES
        view/Main.qml
        view/component_library/style/Colors.qml
        view/component_library/style/RoleEnum.qml
        view/component_library/button/MyButton.qml
        view/component_library/button/MyIcon.qml
        view/component_library/button/SearchButton.qml
        view/component_library/button/MySlider.qml
        view/component_library/button/MySwitch.qml
        view/component_library/button/MyMenu.qml
        view/component_library/button/MyProgress.qml
        view/component_library/button/VerificationDialog.qml
        view/component_library/button/NotificationDialog.qml

        view/AppMenuDesktop.qml
        view/AppMenuAplication.qml
        view/menu/MyMenuApp.qml

        view/AppBody.qml

        view/home/HomeView.qml
        view/home/components/HomeHeader.qml
        view/home/components/FeatureList.qml
        view/home/components/FeatureDelegate.qml

        view/model/ModelsView.qml
        view/model/components/ModelHeader.qml
        view/model/components/ModelBody.qml
        view/model/components/offline/OfflineModelView.qml
        view/model/components/offline/OfflineHeader.qml
        view/model/components/offline/OfflineList.qml
        view/model/components/offline/OfflineDelegate.qml
        view/model/components/offline/DownloadButton.qml
        view/model/components/online/OnlineModelView.qml
        view/model/components/online/OnlineHeader.qml
        view/model/components/online/OnlineList.qml
        view/model/components/online/OnlineDelegate.qml
        view/model/components/online/InputApikey.qml
        view/model/components/online/ApikeyButton.qml

        view/chat/ChatView.qml
        view/chat/components/ChatHeader.qml
        view/chat/components/HistoryDrawer.qml
        view/chat/components/ModelSettingsDrawer.qml
        view/chat/components/ChatBody.qml
        view/chat/components/chat/InputPrompt.qml
        view/chat/components/chat/MessageDelegate.qml
        view/chat/components/chat/MyMessageList.qml
        view/chat/components/history/HistoryHeader.qml
        view/chat/components/history/HistoryBody.qml
        view/chat/components/history/HistoryList.qml
        view/chat/components/history/HistoryDelegate.qml
        view/chat/components/model_settings/ModelSettingsHeader.qml
        view/chat/components/model_settings/ModelSettingsBody.qml
        view/chat/components/model_settings/ModelAssistantSettings.qml
        view/chat/components/model_settings/ModelInferencesSettings.qml
        view/chat/components/model_settings/ModelInformationSettings.qml
        view/chat/components/model_settings/ModelEngineSettings.qml
        view/chat/components/model_settings/components/ModelSettingsSlider.qml
        view/chat/components/model_settings/components/ModelSettingsSwitch.qml
        view/chat/components/model_settings/components/ModelMenuSettings.qml
        view/chat/components/model/ModelButton.qml
        view/chat/components/model/ModelDialog.qml
        view/chat/components/model/components/ModelDialogHeader.qml
        view/chat/components/model/components/ModelDialogBody.qml
        view/chat/components/model/components/online/OnlineCurrentModelDelegate.qml
        view/chat/components/model/components/online/OnlineCurrentModelList.qml
        view/chat/components/model/components/online/OnlineCurrentModelinformation.qml
        view/chat/components/model/components/online/OnlineCurrentView.qml
        view/chat/components/model/components/offline/OfflineCurrentModelDelegate.qml
        view/chat/components/model/components/offline/OfflineCurrentModelList.qml
        view/chat/components/model/components/offline/OfflineCurrentModelinformation.qml
        view/chat/components/model/components/offline/OfflineCurrentView.qml

        view/SettingsDialog.qml
        view/settings/SettingsHeader.qml
        view/settings/SettingsBody.qml

        view/AppFooter.qml
        view/component_footer/SystemMonitoring.qml
        view/component_footer/Downloading.qml

        RESOURCES
            view/component_library/style/qmldir
        RESOURCE_PREFIX /
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(app${PROJECT_NAME} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.app${PROJECT_NAME}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(app${PROJECT_NAME}
    PRIVATE
        Qt6::Quick
        Qt6::Concurrent
        Qt6::Sql
        Qt::Qml
        Qt6::Core
        Qt::Gui
)

include(GNUInstallDirs)
install(TARGETS app${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/core/model/file/company.json
                        ${CMAKE_CURRENT_BINARY_DIR}/bin/company.json COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/core/model/file/offline_models.json
                        ${CMAKE_CURRENT_BINARY_DIR}/bin/offline_models.json COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/core/model/file/openai_models.json
                        ${CMAKE_CURRENT_BINARY_DIR}/bin/openai_models.json COPYONLY)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/config.h.in
                        ${CMAKE_CURRENT_BINARY_DIR}/config.h COPYONLY)
