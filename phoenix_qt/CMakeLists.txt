cmake_minimum_required(VERSION 3.16)


set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(APPLE)
  option(BUILD_UNIVERSAL "Build a Universal binary on macOS" OFF)
  if(BUILD_UNIVERSAL)
    # Build a Universal binary on macOS
    # This requires that the found Qt library is compiled as Universal binaries.
    set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
  else()
    # Build for the host architecture on macOS
    set(CMAKE_OSX_ARCHITECTURES "${CMAKE_HOST_SYSTEM_PROCESSOR}" CACHE STRING "" FORCE)
  endif()
endif()


set(PROJECTNAME  Phoenix)
project(${PROJECTNAME} VERSION 0.1 LANGUAGES CXX)


set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# add_subdirectory(../phoenix/ llmodel)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Charts Qml Quick Sql)

qt_standard_project_setup(REQUIRES 6.5)

# if(APPLE)
# elseif(UNIX)
# elseif(WIN32)
#         # Enable CUDA
#         find_package(CUDA REQUIRED)
#         set(CUDA_SEPARABLE_COMPILATION ON)
#         set(CUDA_PROPAGATE_HOST_FLAGS OFF)

#         # Include directories and link libraries for GPU
#         include_directories(${CUDA_INCLUDE_DIRS})
#         link_libraries(${CUDA_LIBRARIES})

#         # Define preprocessor macros for CUDA
#         add_definitions(-DGGML_USE_CUDA)
# endif()




# set(CMAKE_INCLUDE_CURRENT_DIR ON)

# set(CMAKE_AUTOUIC ON)
# set(CMAKE_AUTOMOC ON)
# set(CMAKE_AUTORCC ON)

# set(CMAKE_CXX_STANDARD_REQUIRED ON)


# find_package(Qt6 6.4 REQUIRED COMPONENTS Core Quick Sql )

# qt_standard_project_setup()

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
        "images/fillAboutIcon.svg"
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
        "images/phoenix.png"
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
        "images/systemMonitorIcon.svg"
        "images/PhoenixIcon.svg"
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
        "images/speed_dial_195_151.png"
        "images/sppedometer_outer_ring_195_86.png"
        "images/speedometer_track_bg_195_87.png"
        "images/speedometer_needle_ring_195_90.png"
        "images/speedometer_needle_195_142.png"
        "images/okIcon.svg"

        "images/cancelCircle.svg"
        "images/fillCancelCircle.svg"
        "images/okCircle.svg"
        "images/fillOkCircle.svg"

        "fontFamily/DMSans-VariableFont.ttf"
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
    QML_FILES SpeedDisplay.qml
    QML_FILES CustomDot.qml
    QML_FILES AnimationText.qml
    QML_FILES Notification.qml
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
        Qt6::Core
        Qt6::Charts
        Qt::Gui
        Qt::Qml
)



# target_link_libraries(app${PROJECTNAME}
#     PRIVATE llmodel
# )

# set(COMPONENT_NAME_MAIN ${PROJECT_NAME})

# if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
#   set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install CACHE PATH "..." FORCE)
# endif()

# install(TARGETS app${PROJECTNAME} DESTINATION bin COMPONENT ${COMPONENT_NAME_MAIN})

# if(APPLE)
#         add_dependencies(app${PROJECTNAME} ggml-metal)

#         install(
#             TARGETS  llmodel
#                                 llamamodel-mainline-cpu
#                                 llamamodel-mainline-cpu-avxonly
#                                 llamamodel-mainline-metal
#             LIBRARY DESTINATION lib COMPONENT ${COMPONENT_NAME_MAIN}  # .so/.dylib
#             RUNTIME DESTINATION lib COMPONENT ${COMPONENT_NAME_MAIN}  # .dll
#         )

# elseif(UNIX)

# elseif(WIN32)
#     # set_property(TARGET llamamodel-mainline-cuda llamamodel-mainline-cuda-avxonly
#     #              APPEND PROPERTY INSTALL_RPATH "$ORIGIN")

#     install(
#         TARGETS llamamodel-mainline-cuda
#                 llamamodel-mainline-cuda-avxonly
#         RUNTIME_DEPENDENCY_SET llama-cuda-deps
#         LIBRARY DESTINATION lib COMPONENT ${COMPONENT_NAME_MAIN}  # .so/.dylib
#         RUNTIME DESTINATION lib COMPONENT ${COMPONENT_NAME_MAIN}  # .dll
#     )
#         install(
#             RUNTIME_DEPENDENCY_SET llama-cuda-deps
#             PRE_EXCLUDE_REGEXES "^(nvcuda|api-ms-.*)\\.dll$"
#             POST_INCLUDE_REGEXES "(^|[/\\\\])(lib)?(cuda|cublas)" POST_EXCLUDE_REGEXES .
#             DIRECTORIES "${CUDAToolkit_BIN_DIR}"
#             DESTINATION lib COMPONENT ${COMPONENT_NAME_MAIN}
#         )

#     install(
#         TARGETS  llmodel
#                             llama-mainline-kompute
#                             llama-mainline-kompute-avxonly
#                             llamamodel-mainline-kompute
#                             llamamodel-mainline-kompute-avxonly
#         LIBRARY DESTINATION lib COMPONENT ${COMPONENT_NAME_MAIN}  # .so/.dylib
#         RUNTIME DESTINATION lib COMPONENT ${COMPONENT_NAME_MAIN}  # .dll
#     )

#         # # Set CUDA architecture (optional, adjust according to your GPU)
#         # set_target_properties(app${PROJECTNAME} PROPERTIES CUDA_ARCHITECTURES "52;60;61;70;75;80;86")

#         # # Set CUDA runtime library (static or shared)
#         # set_target_properties(app${PROJECTNAME} PROPERTIES CUDA_RUNTIME_LIBRARY Static)
# endif()



include(GNUInstallDirs)
install(TARGETS app${PROJECTNAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
