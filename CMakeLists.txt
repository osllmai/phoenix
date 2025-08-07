cmake_minimum_required(VERSION 3.16)

set(APP_VERSION_MAJOR 0)
set(APP_VERSION_MINOR 1)
set(APP_VERSION_PATCH 5)
set(APP_VERSION_BASE "${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}.${APP_VERSION_PATCH}")
set(APP_VERSION "${APP_VERSION_BASE}")

set(APP_NAME Phoenix)
project(${APP_NAME} VERSION ${APP_VERSION_BASE} LANGUAGES CXX C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_GENERATE_QMLLS_INI ON)

# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core Network)
find_package(Qt6 REQUIRED COMPONENTS Core Quick Concurrent Gui Qml Sql Network Xml TextToSpeech HttpServer)

qt_standard_project_setup(REQUIRES 6.5)

include_directories(
    ${CMAKE_SOURCE_DIR}/core
    ${CMAKE_SOURCE_DIR}/core/model/
    ${CMAKE_SOURCE_DIR}/core/model/offline
    ${CMAKE_SOURCE_DIR}/core/model/online
    ${CMAKE_SOURCE_DIR}/core/conversation
    ${CMAKE_SOURCE_DIR}/core/conversation/chat
    ${CMAKE_SOURCE_DIR}/core/conversation/provider
    ${CMAKE_SOURCE_DIR}/core/library/textprocessor
    ${CMAKE_SOURCE_DIR}/core/library/textprocessor/highlight
    ${CMAKE_SOURCE_DIR}/core/library/textprocessor/highlight/languageHighlightingRules
    ${CMAKE_SOURCE_DIR}/core/library/convert
    ${CMAKE_SOURCE_DIR}/core/library/speech
    ${CMAKE_SOURCE_DIR}/core/developer/
    ${CMAKE_SOURCE_DIR}/core/developer/code
    ${CMAKE_SOURCE_DIR}/core/developer/code/code_generator
    ${CMAKE_SOURCE_DIR}/core/developer/server
    ${CMAKE_SOURCE_DIR}/core/developer/server/entities
    ${CMAKE_SOURCE_DIR}/core/provider
    ${CMAKE_SOURCE_DIR}/core/log
    ${CMAKE_CURRENT_BINARY_DIR}
)

# Include the binary directory for the generated header file
include_directories("${CMAKE_CURRENT_BINARY_DIR}")


set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

qt_add_executable(app${APP_NAME}
    core/main.cpp
    media/image_company/appIcon.rc

    core/database.h core/database.cpp
    core/systemmonitor.h core/systemmonitor.cpp
    core/clipboard.h core/clipboard.cpp

    core/log/logger.h core/log/logger.cpp
    core/log/logcategories.h core/log/logcategories.cpp

    core/model/BackendType.h
    core/model/model.h core/model/model.cpp
    core/model/modelsettings.h core/model/modelsettings.cpp
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
    core/conversation/chat/responselist.h core/conversation/chat/responselist.cpp

    core/provider/onlineprovider.h core/provider/onlineprovider.cpp
    core/provider/offlineprovider.h core/provider/offlineprovider.cpp
    core/provider/provider.h core/provider/provider.cpp

    core/developer/codedeveloperlist.h core/developer/codedeveloperlist.cpp
    core/developer/code/programlanguage.h core/developer/code/programlanguage.cpp
    core/developer/code/codegenerator.h core/developer/code/codegenerator.cpp
    core/developer/code/code_generator/curlcodegenerator.h core/developer/code/code_generator/curlcodegenerator.cpp
    core/developer/code/code_generator/pythonrequestscodegenerator.h core/developer/code/code_generator/pythonrequestscodegenerator.cpp
    core/developer/code/code_generator/nodejsaxioscodegenerator.h core/developer/code/code_generator/nodejsaxioscodegenerator.cpp
    core/developer/code/code_generator/javascriptfetchcodegenerator.h core/developer/code/code_generator/javascriptfetchcodegenerator.cpp

    core/developer/server/crudapi.h core/developer/server/crudapi.cpp
    core/developer/server/entities/modelapi.h core/developer/server/entities/modelapi.cpp
    core/developer/server/entities/chatapi.h core/developer/server/entities/chatapi.cpp
    core/developer/server/chatserver.h core/developer/server/chatserver.cpp

    core/library/speech/speechtotext.h core/library/speech/speechtotext.cpp
    core/library/speech/audiorecorder.h core/library/speech/audiorecorder.cpp

    core/library/convert/converttomd.h core/library/convert/converttomd.cpp

    core/library/textprocessor/messagetextprocessor.h core/library/textprocessor/messagetextprocessor.cpp
    core/library/textprocessor/codecolors.h core/library/textprocessor/codecolors.cpp
    core/library/textprocessor/highlight/syntaxhighlighter.h core/library/textprocessor/highlight/syntaxhighlighter.cpp
    core/library/textprocessor/highlight/highlightingcategory.h
    core/library/textprocessor/highlight/language.h
    core/library/textprocessor/highlight/highlightingrule.h
    core/library/textprocessor/highlight/highlighting.h core/library/textprocessor/highlight/highlighting.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/pythonhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/pythonhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/csharphighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/csharphighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/cpphighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/cpphighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/typescripthighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/typescripthighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/javahighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/javahighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/gohighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/gohighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/bashhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/bashhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/latexhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/latexhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/htmlhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/htmlhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/phphighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/phphighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/jsonhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/jsonhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/javascripthighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/javascripthighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/markdownhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/markdownhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/swifthighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/swifthighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/kotlinhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/kotlinhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/rusthighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/rusthighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/rubyhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/rubyhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/sqlhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/sqlhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/rhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/rhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/perlhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/perlhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/scalahighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/scalahighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/haskellhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/haskellhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/luahighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/luahighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/assemblyhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/assemblyhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/cmakehighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/cmakehighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/makefilehighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/makefilehighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/qmllightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/qmllightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/inihighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/inihighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/yamlhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/yamlhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/dockerfilehighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/dockerfilehighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/batchhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/batchhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/powershellhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/powershellhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/shellscripthighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/shellscripthighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/xmlhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/xmlhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/csshighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/csshighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/csvhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/csvhighlightingrules.cpp
    core/library/textprocessor/highlight/languageHighlightingRules/tomlhighlightingrules.h core/library/textprocessor/highlight/languageHighlightingRules/tomlhighlightingrules.cpp
)

qt_add_resources(app${APP_NAME}
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
        media/icon/favorite.svg
        media/icon/disFavorite.svg
        media/icon/likeFill.svg
        media/icon/disLikeFill.svg
        media/icon/speaker.svg
        media/icon/speakerFill.svg
        media/icon/history.svg
        media/icon/settings.svg
        media/icon/settingsFill.svg
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
        media/icon/down.svg
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
        media/icon/themeDark.png
        media/icon/themeDefualt.png
        media/icon/themeLight.png
        media/icon/rewrite.svg
        media/icon/colorPalette.svg
        media/icon/colorPaletteFill.svg
        media/icon/privacy.svg
        media/icon/privacyFill.svg
        media/icon/terms_of_Use.svg
        media/icon/terms_of_UseFill.svg
        media/icon/microphoneOff.svg
        media/icon/microphoneOffFill.svg
        media/icon/microphoneOn.svg
        media/icon/microphoneOnFill.svg
        media/icon/developer.svg
        media/icon/developerFill.svg
        media/icon/notFoundHistory.svg
        media/icon/notFoundModel.svg
        media/icon/listView.svg
        media/icon/gridView.svg
        media/icon/selectFile.svg

        media/icon/fileCsv.svg
        media/icon/fileDocx.svg
        media/icon/fileHtm.svg
        media/icon/fileHtml.svg
        media/icon/fileJpg.svg
        media/icon/fileJson.svg
        media/icon/fileMd.svg
        media/icon/fileMp3Audio.svg
        media/icon/filePdf.svg
        media/icon/filePng.svg
        media/icon/filePptx.svg
        media/icon/fileWav.svg
        media/icon/fileXlsx.svg
        media/icon/fileXml.svg


        media/icon/maximizeH.svg
        media/icon/maximize.svg
        media/icon/minimize.svg
        media/icon/minus.svg


        media/icon/twitter.svg
        media/icon/linkedin.svg


        media/image_company/user.svg
        media/image_company/Phoenix.svg
        media/image_company/Phoenix.png
        media/image_company/Bert.svg
        media/image_company/Meta.svg
        media/image_company/Mistral.svg
        media/image_company/Databricks.svg
        media/image_company/Microsoft.svg
        media/image_company/Qwen.svg
        media/image_company/Replit.svg
        media/image_company/BigCode.png
        media/image_company/Openai.svg
        media/image_company/Claude.svg
        media/image_company/Cohere.svg
        media/image_company/Deepseek.svg
        media/image_company/Google.svg
        media/image_company/Nvidia.svg
        media/image_company/Whisper.svg

        media/fonts/DMSans-Regular.ttf

        media/media.qrc
        view/view.qrc
)

qt_policy(SET QTP0004 NEW)

qt_add_qml_module(app${APP_NAME}
    URI ${APP_NAME}
    VERSION 1.0

    QML_FILES
        view/Main.qml

        view/component_library/style/Colors.qml
        view/component_library/style/RoleEnum.qml
        view/component_library/button/MyButton.qml
        view/component_library/button/MyComboBox.qml
        view/component_library/button/MyIcon.qml
        view/component_library/button/SearchButton.qml
        view/component_library/button/MySlider.qml
        view/component_library/button/MySwitch.qml
        view/component_library/button/MyMenu.qml
        view/component_library/button/MyProgress.qml
        view/component_library/button/VerificationDialog.qml
        view/component_library/button/NotificationDialog.qml
        view/component_library/button/MyToolTip.qml
        view/component_library/button/MyCopyButton.qml
        view/component_library/model/ModelSelectComboBox.qml
        view/component_library/model_settings/components/APISettings.qml
        view/component_library/model_settings/components/SocketSettings.qml
        view/component_library/model_settings/components/button/ModelTextEdit.qml
        view/component_library/model_settings/components/button/ModelTextCopyBox.qml

        view/AppMenu.qml
        view/AppMenuDrawer.qml
        view/menu/MyMenuButton.qml
        view/menu/MyOpenMenuButton.qml

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
        view/model/components/offline/OfflineBody.qml
        view/model/components/offline/components/OfflineGridView.qml
        view/model/components/offline/components/OfflineListView.qml
        view/model/components/offline/components/OfflineBoxDelegate.qml
        view/model/components/offline/components/OfflineRowDelegate.qml
        view/model/components/offline/components/components/DownloadButton.qml
        view/model/components/offline/components/components/OfflineDelegateTitleAndCopyButton.qml
        view/model/components/offline/components/components/OfflineDelegateInfoBox.qml
        view/model/components/offline/components/components/OfflineInformationModel.qml

        view/model/components/online/OnlineModelView.qml
        view/model/components/online/OnlineHeader.qml
        view/model/components/online/OnlineBody.qml
        view/model/components/online/components/OnlineGridView.qml
        view/model/components/online/components/OnlineListView.qml
        view/model/components/online/components/OnlineBoxDelegate.qml
        view/model/components/online/components/OnlineRowDelegate.qml
        view/model/components/online/components/components/InputApikey.qml
        view/model/components/online/components/components/ApikeyButton.qml
        view/model/components/online/components/components/OnlineDelegateTitleAndCopyButton.qml
        view/model/components/online/components/components/OnlineDelegateInfoBox.qml
        view/model/components/online/components/components/OnlineInformationModel.qml

        view/chat/ChatView.qml
        view/chat/components/ChatHeader.qml
        view/chat/components/ChatBody.qml
        view/chat/components/HistoryDrawer.qml
        view/chat/components/ModelSettingsChatDrawer.qml
        view/chat/components/ModelChatComboBox.qml
        view/chat/components/chat/InputPrompt.qml
        view/chat/components/chat/MessageDelegate.qml
        view/chat/components/chat/MyMessageList.qml
        view/chat/components/chat/components/FileConverteInputPrompt.qml
        view/chat/components/chat/components/AudioRecoderInput.qml
        view/chat/components/chat/components/TextInput.qml
        view/chat/components/history/HistoryHeader.qml
        view/chat/components/history/HistoryBody.qml
        view/chat/components/history/HistoryList.qml
        view/chat/components/history/HistoryDelegate.qml


        view/component_library/model_settings/ModelSettingsView.qml
        view/component_library/model_settings/ModelSettingsHeader.qml
        view/component_library/model_settings/ModelSettingsBody.qml
        view/component_library/model_settings/components/ModelAssistantSettings.qml
        view/component_library/model_settings/components/ModelInferencesSettings.qml
        view/component_library/model_settings/components/ModelInformationSettings.qml
        view/component_library/model_settings/components/ModelEngineSettings.qml
        view/component_library/model_settings/components/button/ModelSettingsSlider.qml
        view/component_library/model_settings/components/button/ModelSettingsSwitch.qml
        view/component_library/model_settings/components/button/ModelMenuSettings.qml

        view/component_library/model/ModelSelectView.qml
        view/component_library/model/components/ModelSelectHeader.qml
        view/component_library/model/components/ModelSelectBody.qml
        view/component_library/model/components/online/InputApikeyDialog.qml
        view/component_library/model/components/online/OnlineCurrentModelDelegate.qml
        view/component_library/model/components/online/OnlineCurrentModelList.qml
        view/component_library/model/components/online/OnlineCurrentModelinformation.qml
        view/component_library/model/components/online/OnlineCurrentView.qml
        view/component_library/model/components/offline/OfflineCurrentModelDelegate.qml
        view/component_library/model/components/offline/OfflineCurrentModelList.qml
        view/component_library/model/components/offline/OfflineCurrentModelinformation.qml
        view/component_library/model/components/offline/OfflineCurrentView.qml

        view/developer/DeveloperView.qml
        view/developer/components/DeveloperHeader.qml
        view/developer/components/DeveloperBody.qml
        view/developer/components/model/ModelDeveloperComboBox.qml
        view/developer/components/model/ModelDeveloperView.qml
        view/developer/components/command_line/CommandLineInterface.qml
        view/developer/components/command_line/CommandLineInterfaceApp.qml
        view/developer/components/model_settings/ModelSettingsDeveloperView.qml
        view/developer/components/model_settings/ModelSettingsDeveloperDrawer.qml
        view/developer/components/code/CodeDeveloper.qml
        view/developer/components/code/EditCodeDeveloper.qml

        view/SettingsDialog.qml
        view/settings/SettingsHeader.qml
        view/settings/SettingsBody.qml
        view/settings/SettingsMenu.qml
        view/settings/SettingsMenuDrawer.qml
        view/settings/components/SettingsAbout.qml
        view/settings/components/SettingsTheme.qml
        view/settings/components/SettingsSpeech.qml
        view/settings/components/SettingsTerms_of_Use.qml
        view/settings/components/SettingsPrivacy.qml
        view/settings/components/SettingsMenuButton.qml
        view/settings/components/SettingsSlider.qml
        view/settings/components/ThemeOption.qml
        view/settings/components/OpenMenuSettingsButton.qml

        view/AppFooter.qml
        view/footer/SystemMonitoring.qml
        view/footer/Downloading.qml

        view/AppHeader.qml

    RESOURCES
        view/component_library/style/qmldir
    RESOURCE_PREFIX /
    SOURCES core/updatechecker.h core/updatechecker.cpp
    QML_FILES view/UpdateAvailable.qml
    QML_FILES view/footer/DownloadProgressComboBox.qml
    QML_FILES view/footer/DownloadingDelegate.qml
)

#for show logger-contect (file name, message line, ...)
add_definitions(-DQT_MESSAGELOGCONTEXT)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(app${APP_NAME} PROPERTIES
   MACOSX_BUNDLE_GUI_IDENTIFIER com.example.app${APP_NAME}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(app${APP_NAME}
    PRIVATE
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Concurrent
        Qt${QT_VERSION_MAJOR}::Sql
        Qt${QT_VERSION_MAJOR}::Network
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::TextToSpeech
        Qt${QT_VERSION_MAJOR}::HttpServer
        Qt${QT_VERSION_MAJOR}::Xml
        Qt::Qml
        Qt::Gui
)

include(GNUInstallDirs)
install(TARGETS app${APP_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# set(BIN_DIR ${CMAKE_CURRENT_BINARY_DIR}/bin)
set(BIN_DIR ${CMAKE_CURRENT_BINARY_DIR})

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/config.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/config.h
)

#copy company.json
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/resources/models/company.json ${BIN_DIR}/models/company.json COPYONLY)


#copy online-models
set(ONLINE_JSON_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/resources/models/online_models)
set(ONLINE_JSON_DEST_DIR ${BIN_DIR}/models/online_models)

file(GLOB ONLINE_JSON_FILES "${ONLINE_JSON_SOURCE_DIR}/*.json")

foreach(json_file ${ONLINE_JSON_FILES})
    get_filename_component(json_filename ${json_file} NAME)
    configure_file(${json_file} ${ONLINE_JSON_DEST_DIR}/${json_filename} COPYONLY)
endforeach()


#copy offline-model
set(OFFLINE_JSON_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/resources/models/offline_models)
set(OFFLINE_JSON_DEST_DIR ${BIN_DIR}/models/offline_models)

file(GLOB OFFLINE_JSON_FILES "${OFFLINE_JSON_SOURCE_DIR}/*.json")

foreach(json_file ${OFFLINE_JSON_FILES})
    get_filename_component(json_filename ${json_file} NAME)
    configure_file(${json_file} ${OFFLINE_JSON_DEST_DIR}/${json_filename} COPYONLY)
endforeach()


#copy python provider for online-model
if(WIN32)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/resources/providers/online_provider/dist/main_provider.exe ${BIN_DIR}/providers/online_provider/main_provider.exe COPYONLY)
else()
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/resources/providers/online_provider/main_provider.py ${BIN_DIR}/providers/online_provider/main_provider.py COPYONLY)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/resources/providers/online_provider/provider.py ${BIN_DIR}/providers/online_provider/provider.py COPYONLY)
endif()


#copy whisper
file(COPY ${CMAKE_SOURCE_DIR}/resources/whisper/cpu-device DESTINATION ${BIN_DIR}/whisper)
file(COPY ${CMAKE_SOURCE_DIR}/resources/whisper/cuda-device DESTINATION ${BIN_DIR}/whisper)

#copy ConvertToMD
configure_file(${CMAKE_SOURCE_DIR}/resources/markitdown/markitdown.exe ${BIN_DIR}/markitdown/markitdown.exe COPYONLY)

#copy exe provider for offline-model
if(WIN32)
    # Gather EXE files
    file(GLOB exe_files "${CMAKE_SOURCE_DIR}/resources/providers/local_provider/*.exe")
    foreach(exe_file ${exe_files})
        get_filename_component(exe_filename ${exe_file} NAME)
        configure_file(${exe_file} ${BIN_DIR}/${exe_filename} COPYONLY)
    endforeach()

    # Gather DLL files
    file(GLOB dll_files "${CMAKE_SOURCE_DIR}/resources/providers/local_provider/*.dll")
    foreach(dll_file ${dll_files})
        get_filename_component(dll_filename ${dll_file} NAME)
        configure_file(${dll_file} ${BIN_DIR}/${dll_filename} COPYONLY)
    endforeach()
endif()

