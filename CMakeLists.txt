cmake_minimum_required(VERSION 3.16)

project(projekt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Widgets Charts)

set(CMAKE_AUTORCC ON)

qt_standard_project_setup()

qt_add_executable(appprojekt
    qml.qrc
    main.cpp
)

qt_add_qml_module(appprojekt
    URI projekt
    VERSION 1.0
    QML_FILES Main.qml Status.qml ColorInterpolation/ColorInterpolation.qml ColorInterpolation/InterpolationStop.qml TemperatureDial.qml EffectPreview.qml EffectColorArea.qml CustomIcon.qml Preset.qml Effect.qml LEDControlScreen.qml CurrentStatusScreen.qml ConfigActScreen.qml
)

set_target_properties(appprojekt PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appprojekt
    PRIVATE Qt6::Quick Qt6::Widgets Qt6::Charts
)

install(TARGETS appprojekt
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

add_subdirectory("./qt-project.org/imports/QtGraphicalEffects") # where 'QtGraphicalEffects' is the path to QtGraphicalEffects

# These two lines make Qt Creator recognize QGE QML module.
list(APPEND QML_DIRS "${CMAKE_CURRENT_BINARY_DIR}/") # As above
set(QML_IMPORT_PATH "${QML_DIRS}" CACHE STRING "Qt Creator 4.1 extra qml import paths")
