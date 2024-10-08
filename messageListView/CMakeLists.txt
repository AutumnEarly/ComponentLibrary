cmake_minimum_required(VERSION 3.16)

project(messageListView VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(appmessageListView
    main.cpp
)

qt_add_qml_module(appmessageListView
    URI messageListView
    VERSION 1.0
    QML_FILES main.qml
    RESOURCES resource.qrc
    QML_FILES messageQueueView/MessageQueueView.qml
    QML_FILES messageQueueView/resource/MessageView.qml
    QML_FILES messageQueueView/resource/Background.qml
    QML_FILES messageQueueView/resource/ScroolBar.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appmessageListView PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmessageListView
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmessageListView
    PRIVATE Qt6::Quick)

include(GNUInstallDirs)
install(TARGETS appmessageListView
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
