import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

ApplicationWindow {
    readonly property real aspectRatio: width / height
    property bool menuOpened: drawer.position
    property string buttonFontColor: Material.theme === Material.Dark ? "#ffffff" : "#000000"
    property QtObject activeDrawerItem: ledNavigation
    property string activeLoaderItem: "CurrentStatusScreen.qml"

    id: window
    width: 1280
    height: 720
    visible: true

    Material.theme: Material.System
    Material.accent: Material.Teal

    Button {
        z: 1

        icon.color: Material.color(Material.Teal)
        icon.source: menuOpened ? "qrc:/icons/menu_open.svg" : "qrc:/icons/menu.svg"

        // Hiding background shading
        highlighted: true
        Material.accent: "#00ffffff"
        Material.foreground: buttonFontColor

        anchors {
            right: parent.right
            top: parent.top
        }

        onClicked: drawer.open()
    }

    Drawer {
        id: drawer
        width: aspectRatio < 0.75 ? 0.66 * window.width : 0.33 * window.width
        height: window.height
        dragMargin: window.width * 0.05

        Label {
            id: ledControlLabel
            text: "LED Control"
            font.bold: true
            font.pixelSize: 12

            anchors {
                top: parent.top
                left: parent.left
                topMargin: 16
                leftMargin: 16
            }
        }

        Button {
            id: ledNavigation
            text: "Configuration and presets"
            font.bold: ledNavigation == activeDrawerItem

            icon.color: Material.color(Material.Teal)
            icon.source: "qrc:/icons/lightbulb.svg"

            // Hiding background shading
            highlighted: true
            Material.background: "#00ffffff"
            Material.foreground: Material.theme === Material.Dark ? buttonFontColor : Material.foreground

            anchors {
                top: ledControlLabel.bottom
                left: parent.left
                leftMargin: 8
            }

            onClicked: {
                activeDrawerItem = ledNavigation
                activeLoaderItem = "LEDControlScreen.qml"
            }
        }

        Label {
            id: heatingControlLabel
            text: "Heating Control"
            font.bold: true
            font.pixelSize: 12

            anchors {
                top: ledNavigation.bottom
                left: parent.left
                topMargin: 16
                leftMargin: 16
            }
        }

        Button {
            id: heatingStatusNavigation
            text: "Current status"
            font.bold: heatingStatusNavigation == activeDrawerItem

            icon.color: Material.color(Material.Teal)
            icon.source: "qrc:/icons/heat_pump.svg"

            // Hiding background shading
            highlighted: true
            Material.background: "#00ffffff"
            Material.foreground: Material.theme === Material.Dark ? buttonFontColor : Material.foreground

            anchors {
                top: heatingControlLabel.bottom
                left: parent.left
                leftMargin: 8
            }

            onClicked: {
                activeDrawerItem = heatingStatusNavigation
                activeLoaderItem = "CurrentStatusScreen.qml"
            }
        }

        Button {
            id: heatingActuatorsNavigation
            text: "Actuators"
            font.bold: heatingActuatorsNavigation == activeDrawerItem

            icon.color: Material.color(Material.Teal)
            icon.source: "qrc:/icons/water_pump.svg"

            // Hiding background shading
            highlighted: true
            Material.background: "#00ffffff"
            Material.foreground: Material.theme === Material.Dark ? buttonFontColor : Material.foreground

            anchors {
                top: heatingStatusNavigation.bottom
                left: parent.left
                leftMargin: 8
            }

            onClicked: {
                activeDrawerItem = heatingActuatorsNavigation
                activeLoaderItem = "ActuatorsScreen.qml"
            }
        }

        Button {
            id: heatingConfigurationNavigation
            text: "Configuration"
            font.bold: heatingConfigurationNavigation == activeDrawerItem

            icon.color: Material.color(Material.Teal)
            icon.source: "qrc:/icons/tune.svg"

            // Hiding background shading
            highlighted: true
            Material.background: "#00ffffff"
            Material.foreground: Material.theme === Material.Dark ? buttonFontColor : Material.foreground

            anchors {
                top: heatingActuatorsNavigation.bottom
                left: parent.left
                leftMargin: 8
            }

            onClicked: {
                activeDrawerItem = heatingConfigurationNavigation
                activeLoaderItem = "ConfigurationScreen.qml"
            }
        }
    }

    Loader {
        id: content
        anchors.fill: parent
        source: activeLoaderItem
    }
}