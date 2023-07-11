import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCharts 2.0

Flickable {
    id: root

    property real roomTemp: 24.5 // Connect to arduino sensor
    property real releaseTemp: 34.5 // Connect to arduino sensor
    property real returnTemp: 23.5 // Connect to arduino sensor
    property real dialsLeftMargin: (dialsContainer.width
                                    - roomTempDial.width
                                    - releaseTempDial.width
                                    - returnTempDial.width) / 2
    property bool heater1On: true  // Read from arduino
    property bool heater2On: false  // Read from arduino
    property bool pumpOn: true  // Read from arduino
    property real statusLeftMargin: (statusContainer.width
                                     - heater1Status.width
                                     - heater2Status.width
                                     - pumpStatus.width) / 2

    //color: "#100000ff"

    clip: true
    anchors.fill: parent

    contentWidth: parent.width
    contentHeight: temperaturesLabel.height
                   + dialsContainer.height
                   + heaterPumpLabel.height
                   + statusContainer.height
                   + temperatureHistoryChart.height
                   + 300

    ScrollBar.vertical: ScrollBar {
        parent: root.parent
        anchors.top: root.top
        anchors.left: root.right
        anchors.bottom: root.bottom
    }

    // Current temperatures label
    Label {
        id: temperaturesLabel
        text: "Temperatures"
        font.pixelSize: 28

        anchors {
            top: parent.top
            left: parent.left
            topMargin: 48
            leftMargin: 32
        }
    }

    // Current temperatures
    Rectangle {
        id: dialsContainer
        width: parent.width * 3 / 4
        height: childrenRect.height

        color: "#00000000"

        anchors {
            top: temperaturesLabel.bottom
            horizontalCenter: parent.horizontalCenter

            margins: 32
            leftMargin: 48
        }

        TemperatureDial {
            id: roomTempDial

            width: 150
            height: 150

            labelText: "Room"

            initialTemperatureValue: roomTemp

            enabled: false

            anchors {
                top: parent.top
                left: parent.left
            }
        }

        TemperatureDial {
            id: releaseTempDial

            width: 150
            height: 150

            labelText: "Release"

            initialTemperatureValue: releaseTemp

            enabled: false

            anchors {
                top: parent.top
                left: roomTempDial.right

                leftMargin: dialsLeftMargin
            }
        }

        TemperatureDial {
            id: returnTempDial

            width: 150
            height: 150

            labelText: "Return"

            initialTemperatureValue: returnTemp

            enabled: false

            anchors {
                top: parent.top
                left: releaseTempDial.right

                leftMargin: dialsLeftMargin
            }
        }
    }

    // Heater and pump label
    Label {
        id: heaterPumpLabel
        text: "Heater and Pump"
        font.pixelSize: 28

        anchors {
            top: dialsContainer.bottom
            left: parent.left
            topMargin: 32
            leftMargin: 32
        }
    }

    // Heater and pump statuses
    Rectangle {
        id: statusContainer
        width: parent.width * 3 / 4
        height: childrenRect.height

        color: "#00000000"

        anchors {
            top: heaterPumpLabel.bottom
            horizontalCenter: parent.horizontalCenter

            margins: 32
            leftMargin: 48
        }

        Status {
            id: heater1Status

            width: 150
            height: 150

            labelText: "Heater 1: " + (heater1On ? "ON" : "OFF")
            statusIconSource: "qrc:/icons/water_heater_1.svg"
            statusIconColor: heater1On ? "darkgreen" : "darkred"

            anchors {
                top: parent.top
                left: parent.left
            }
        }

        Status {
            id: heater2Status

            width: 150
            height: 150

            labelText: "Heater 2: " + (heater2On ? "ON" : "OFF")
            statusIconSource: "qrc:/icons/water_heater_2.svg"
            statusIconColor: heater2On ? "darkgreen" : "darkred"

            anchors {
                top: parent.top
                left: heater1Status.right

                leftMargin: statusLeftMargin
            }
        }

        Status {
            id: pumpStatus

            width: 150
            height: 150

            labelText: "Pump: " + (pumpOn ? "ON" : "OFF")
            statusIconSource: "qrc:/icons/water_pump.svg"
            statusIconColor: pumpOn ? "darkgreen" : "darkred"

            anchors {
                top: parent.top
                left: heater2Status.right

                leftMargin: dialsLeftMargin
            }
        }
    }

    // Temperature history label
    Label {
        id: temperatureHistoryLabel
        text: "Temperature history"
        font.pixelSize: 28

        anchors {
            top: statusContainer.bottom
            left: parent.left
            topMargin: 32
            leftMargin: 32
        }
    }

    ChartView {
        id: temperatureHistoryChart
        width: parent.width * 3 / 4
        height: width * 9 / 16

        anchors {
            top: temperatureHistoryLabel.bottom
            horizontalCenter: parent.horizontalCenter

            topMargin: 32
        }

        ValueAxis {
            id: yAxis
            min: 0
            max: 40
            labelFormat: "%.0f"
        }

        LineSeries {
            id: lineSeries1
            axisY: yAxis
            name: "Room temperature"
            width: 3
            XYPoint { x: 0; y: 22 }
            XYPoint { x: 1; y: 22.9 }
            XYPoint { x: 2; y: 23.5 }
            XYPoint { x: 3; y: 23.9 }
            XYPoint { x: 4; y: 24.1 }
        }
    }
}
