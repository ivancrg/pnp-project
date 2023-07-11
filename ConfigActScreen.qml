import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCharts 2.0

Flickable {
    id: root

    property real roomTemp: 24.5 // Connect to arduino data
    property real roomIntervalTemp: 5 // Connect to arduino data
    property real heater1DeltaTemp: 34.5 // Connect to arduino data
    property real heater2DeltaTemp: 23.5 // Connect to arduino data
    property real pumpDeltaTemp: 23.5 // Connect to arduino data

    property real dialsLeftMargin: (dialsContainer.width
                                    - roomDial.width
                                    - roomIntervalDial.width
                                    - heater1DeltaDial.width
                                    - heater2DeltaDial.width
                                    - pumpDeltaDial.width) / 4
    property bool heater1On: true  // Read from arduino
    property bool heater2On: false  // Read from arduino
    property bool pumpOn: true  // Read from arduino

    //color: "#100000ff"

    clip: true
    anchors.fill: parent

    contentWidth: parent.width
    contentHeight: 0
                   + 300

    ScrollBar.vertical: ScrollBar {
        parent: root.parent
        anchors.top: root.top
        anchors.left: root.right
        anchors.bottom: root.bottom
    }

    // Temperatures configuration label
    Label {
        id: temperaturesConfigLabel
        text: "Temperatures configuration"
        font.pixelSize: 28

        anchors {
            top: parent.top
            left: parent.left
            topMargin: 48
            leftMargin: 32
        }
    }

    // Configure temperatures
    Rectangle {
        id: dialsContainer
        width: parent.width * 3 / 4
        height: childrenRect.height

        color: "#00000000"

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
            onTemperatureValueChanged: { console.log("Arduino update room") }

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
            onTemperatureValueChanged: { console.log("Arduino update room interval") }

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
            onTemperatureValueChanged: { console.log("Arduino update heater1") }

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
            onTemperatureValueChanged: { console.log("Arduino update heater2") }

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
            onTemperatureValueChanged: { console.log("Arduino update pump") }

            hoverEnabled: true
            hoverText: "Minimum temperature delta between release and return temperatures (in favour of release) in order for the pump to be turned on."

            anchors {
                top: parent.top
                left: heater2DeltaDial.right

                leftMargin: dialsLeftMargin
            }
        }
    }

    // Heater and pump label
    Label {
        id: heaterPumpLabel
        text: "Actuators"
        font.pixelSize: 28

        anchors {
            top: dialsContainer.bottom
            left: parent.left
            topMargin: 32
            leftMargin: 32
        }
    }


}
