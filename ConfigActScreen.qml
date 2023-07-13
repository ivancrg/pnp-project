import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCharts 2.0
//import HeatingControl

Flickable {
    id: root

//    HeatingC { id: heatingControl }

    property real roomTemp: HeatingC.temperatures["p_room"]
    property real roomIntervalTemp: HeatingC.temperatures["p_room_int"]
    property real heater1DeltaTemp: HeatingC.temperatures["p_heater_1_delta"]
    property real heater2DeltaTemp: HeatingC.temperatures["p_heater_2_delta"]
    property real pumpDeltaTemp: HeatingC.temperatures["p_pump_delta"]
    property real dialsLeftMargin: (dialsContainer.width
                                    - roomDial.width
                                    - roomIntervalDial.width
                                    - heater1DeltaDial.width
                                    - heater2DeltaDial.width
                                    - pumpDeltaDial.width) / 4

    property bool heater1On: HeatingC.relays["heater_1"]
    property bool heater2On: HeatingC.relays["heater_2"]
    property bool pumpOn: HeatingC.relays["pump"]
    property real switchsLeftMargin: (switchesContainer.width
                                    - heater1Switch.width
                                    - heater2Switch.width
                                    - pumpSwitch.width) / 2


    property string currentActiveMode: HeatingC.heatingMode
    property string customModeName: "custom_mode"
    property string rapidModeName: "rapid_mode"
    property string autoModeName: "auto_mode"

    property bool temperatureConfigVisible: currentActiveMode == autoModeName
    property bool actuatorsConfigVisible: currentActiveMode == customModeName || currentActiveMode == rapidModeName
    property bool actuatorsConfigEnabled: currentActiveMode !== rapidModeName

    property string buttonFontColor: Material.theme === Material.Dark ? "#ffffff" : "#000000"

    property string activePort: ArduinoComm.selectedPort

    onActivePortChanged: HeatingC.pullArduinoParameters()

    onCurrentActiveModeChanged: console.log("ACTIVE MODE CHANGE", currentActiveMode)

    Component.onCompleted: {
        onActivePortChanged: HeatingC.pullArduinoParameters()

        if (currentActiveMode == rapidModeName) {
            heater1Switch.position = 1;
            heater2Switch.position = 1;
            pumpSwitch.position = 1;
        }
    }

    clip: true
    anchors.fill: parent

    contentWidth: parent.width
    contentHeight: temperaturesConfigLabel.height
                   + dialsContainer.height
                   + actuatorsLabel.height
                   + 300

    ScrollBar.vertical: ScrollBar {
        parent: root.parent
        anchors.top: root.top
        anchors.left: root.right
        anchors.bottom: root.bottom
    }    

    Button {
        id: refreshDataButton

        icon.color: Material.color(Material.Teal)
        icon.source: "qrc:/icons/refresh.svg"

        // Hiding background shading
        highlighted: true
        Material.accent: "#00ffffff"
        Material.foreground: buttonFontColor

        anchors {
            right: parent.right
            top: parent.top
        }

        onClicked: HeatingC.pullArduinoParameters()
    }

    // Mode selection label
    Label {
        id: modeSelectionLabel
        text: "Modes"
        font.pixelSize: 28

        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 32
        }
    }

    // Mode selection
    ModeSelection {
        id: modeSelection
        width: parent.width * 3 / 4
        height: 35
        activeMode: currentActiveMode
        onActiveModeChanged: {
            HeatingC.updateHeatingMode(activeMode)
        }

        onCustomModeClicked: {
            heater1Switch.position = heater2Switch.position = pumpSwitch.position = 0;
            HeatingC.updateRelay("heater_1", false);
            HeatingC.updateRelay("heater_2", false);
            HeatingC.updateRelay("pump", false);
        }

        onRapidModeClicked: {
            heater1Switch.position = 1;
            heater2Switch.position = 1;
            pumpSwitch.position = 1;
        }

        anchors {
            top: modeSelectionLabel.bottom
            horizontalCenter: parent.horizontalCenter

            margins: 32
            leftMargin: 48
        }
    }

    // Temperatures configuration label
    Label {
        id: temperaturesConfigLabel
        text: "Temperatures configuration"
        font.pixelSize: 28
        visible: temperatureConfigVisible

        anchors {
            top: modeSelection.bottom
            left: parent.left
            topMargin: 32
            leftMargin: 32
        }
    }

    // Configure temperatures
    Item {
        id: dialsContainer
        width: parent.width * 3 / 4
        height: childrenRect.height
        visible: temperatureConfigVisible

        anchors {
            top: temperaturesConfigLabel.bottom
            horizontalCenter: parent.horizontalCenter

            margins: 32
            leftMargin: 48
        }

        TemperatureDial {
            id: roomDial
            width: 150; height: 150

            labelText: "Room"
            initialTemperatureValue: roomTemp
            onPressedChanged: if (!pressed) HeatingC.updateTemperature("p_room", temperatureValue)

            hoverEnabled: true
            hoverText: "Wanted room temperature."

            anchors {
                top: parent.top
                left: parent.left
            }
        }

        TemperatureDial {
            id: roomIntervalDial
            width: 150; height: 150

            labelText: "Room Interval"
            dialMinValue: 0; dialMaxValue: 5
            initialTemperatureValue: roomIntervalTemp
            onPressedChanged: if (!pressed) HeatingC.updateTemperature("p_room_int", temperatureValue)

            hoverEnabled: true
            hoverText: "Describes maximum deviation from wanted room temperature in order for it to be considered correct."

            anchors {
                top: parent.top
                left: roomDial.right

                leftMargin: dialsLeftMargin
            }
        }

        TemperatureDial {
            id: heater1DeltaDial
            width: 150; height: 150

            labelText: "Heater 1 Delta"
            dialMinValue: 0; dialMaxValue: 10
            initialTemperatureValue: heater1DeltaTemp
            onPressedChanged: if (!pressed) HeatingC.updateTemperature("p_heater_1_delta", temperatureValue)

            hoverEnabled: true
            hoverText: "Minimum temperature delta between current and wanted room temperatures (in favour of wanted) in order for Heater 1 to be turned on."

            anchors {
                top: parent.top
                left: roomIntervalDial.right

                leftMargin: dialsLeftMargin
            }
        }

        TemperatureDial {
            id: heater2DeltaDial
            width: 150; height: 150

            labelText: "Heater 2 Delta"
            dialMinValue: 0; dialMaxValue: 10
            initialTemperatureValue: heater2DeltaTemp
            onPressedChanged: if (!pressed) HeatingC.updateTemperature("p_heater_2_delta", temperatureValue)

            hoverEnabled: true
            hoverText: "Minimum temperature delta between current and wanted room temperatures (in favour of wanted) in order for Heater 2 to be turned on."

            anchors {
                top: parent.top
                left: heater1DeltaDial.right

                leftMargin: dialsLeftMargin
            }
        }

        TemperatureDial {
            id: pumpDeltaDial
            width: 150; height: 150

            labelText: "Pump Delta"
            dialMinValue: 0; dialMaxValue: 20
            initialTemperatureValue: pumpDeltaTemp
            onPressedChanged: if (!pressed) HeatingC.updateTemperature("p_pump_delta", temperatureValue)

            hoverEnabled: true
            hoverText: "Minimum temperature delta between release and return temperatures (in favour of release) in order for the pump to be turned on."

            anchors {
                top: parent.top
                left: heater2DeltaDial.right

                leftMargin: dialsLeftMargin
            }
        }
    }

    // Actuators label
    Label {
        id: actuatorsLabel
        text: "Actuators"
        font.pixelSize: 28
        visible: actuatorsConfigVisible

        anchors {
            top: temperatureConfigVisible ? dialsContainer.bottom : modeSelection.bottom
            left: parent.left
            topMargin: 32
            leftMargin: 32
        }
    }

    Item {
        id: switchesContainer
        width: parent.width * 3 / 4
        height: childrenRect.height
        visible: actuatorsConfigVisible

        anchors {
            top: actuatorsLabel.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 32
            leftMargin: 48
        }

        Switch {
            id: heater1Switch
            text: "Heater 1"
            font.pixelSize: 22
            icon.source: "qrc:/icons/water_heater_1.svg"

            anchors {
                top: parent.top
                left: parent.left
            }

            enabled: actuatorsConfigEnabled

            onPositionChanged: HeatingC.updateRelay("heater_1", position == 1)
        }

        Switch {
            id: heater2Switch
            text: "Heater 2"
            font.pixelSize: 22
            icon.source: "qrc:/icons/water_heater_2.svg"

            anchors {
                top: parent.top
                left: heater1Switch.right
                leftMargin: switchsLeftMargin
            }

            enabled: actuatorsConfigEnabled

            onPositionChanged: HeatingC.updateRelay("heater_2", position == 1)
        }

        Switch {
            id: pumpSwitch
            text: "Pump"
            font.pixelSize: 22
            icon.source: "qrc:/icons/water_pump.svg"

            anchors {
                top: parent.top
                left: heater2Switch.right
                leftMargin: switchsLeftMargin
            }

            enabled: actuatorsConfigEnabled

            onPositionChanged: HeatingC.updateRelay("pump", position == 1)
        }
    }
}
