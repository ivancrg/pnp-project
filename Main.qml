import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
//import ArduinoCommunication

ApplicationWindow {
    title: "LHManager"

    readonly property real aspectRatio: width / height
    property bool menuOpened: drawer.position
    property string buttonFontColor: Material.theme === Material.Dark ? "#ffffff" : "#000000"
    property QtObject activeDrawerItem: ledNavigation
    property string activeLoaderItem: "LEDControlScreen.qml"

    id: window
    width: 1280
    height: 720
    visible: true

    Material.theme: Material.System
    Material.accent: Material.Teal

    property bool light: false

    Button {
        id: menuButton
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

//    ArduinoCom { id: arduinoComm }

    ComboBox {
        id: comPortCombo
        height: menuButton.height - 8
        model: ArduinoComm.availablePortsNames

        anchors {
            right: menuButton.left
            verticalCenter: menuButton.verticalCenter

            rightMargin: 16
        }

        onActivated: ArduinoComm.setSelectedPort(currentValue)
    }

    Label {
        id: availablePortsLabel
        text: "Available ports:"
        font.pixelSize: 12

        anchors {
            right: comPortCombo.left
            verticalCenter: comPortCombo.verticalCenter

            rightMargin: 4
        }
    }

    Button {
        id: refreshPorts
        text: "Refresh COMs"
        font.pixelSize: 12

        icon.color: Material.color(Material.Teal)
        icon.source: "qrc:/icons/refresh.svg"

        // Hiding background shading
        highlighted: true
        Material.accent: "#00ffffff"
        Material.foreground: buttonFontColor

        anchors {
            left: currentPort.right
            verticalCenter: comPortCombo.verticalCenter

            leftMargin: 4
        }

        onClicked: ArduinoComm.refreshAvailablePorts()
    }

    Button {
        id: test
        text: "Test"
        font.pixelSize: 12

        icon.color: Material.color(Material.Teal)
        icon.source: "qrc:/icons/refresh.svg"

        // Hiding background shading
        highlighted: true
        Material.accent: "#00ffffff"
        Material.foreground: buttonFontColor

        anchors {
            left: refreshPorts.right
            verticalCenter: comPortCombo.verticalCenter

            leftMargin: 32
        }

        onClicked: {
            ArduinoComm.write(light ? "1" : 0);
            light = !light;
        }
    }

    Label {
        id: currentPort
        text: "Selected port: "
                + (ArduinoComm.selectedPort !== "" ? ArduinoComm.selectedPort : "N/A")
        font.pixelSize: 12
        color: ArduinoComm.selectedPort == "" ? "darkred" : Material.primaryTextColor

        anchors {
            left: parent.left
            verticalCenter: refreshPorts.verticalCenter

            leftMargin: 32
        }
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
                drawer.close()
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
                drawer.close()
            }
        }

        /*Button {
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
                drawer.close()
            }
        }*/

        Button {
            id: heatingConfigActNavigation
            text: "Configuration and Actuators"
            font.bold: heatingConfigActNavigation == activeDrawerItem

            icon.color: Material.color(Material.Teal)
            icon.source: "qrc:/icons/tune.svg"

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
                activeDrawerItem = heatingConfigActNavigation
                activeLoaderItem = "ConfigActScreen.qml"
                drawer.close()
            }
        }
    }

    Loader {
        id: content
        anchors {
            top: menuButton.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        source: activeLoaderItem
        clip: true
    }
}
