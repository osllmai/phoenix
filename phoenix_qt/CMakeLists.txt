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

        AppMenu.qml
        menu/MyMenuItem.qml

        AppBody.qml

        home/HomeView.qml
        home/Components/Header.qml
        home/Components/FeatureList.qml
        home/Components/FeatureDelegate.qml

    RESOURCES
        component_library/style/qmldir
        "menu/images/homeIcon.svg"
        "menu/images/fillHomeIcon.svg"
        "menu/images/chatIcon.svg"
        "menu/images/fillChatIcon.svg"
        "menu/images/modelIcon.svg"
        "menu/images/fillModelIcon.svg"

        "home/images/indoxGenIcon.svg"
        "home/images/inDoxIcon.svg"
        "home/images/indoxJudgeIcon.svg"
        "home/images/phoenixCliIcon.svg"
        "home/images/phoenixIcon.svg"
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
