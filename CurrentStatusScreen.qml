import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCharts 2.0
import HeatingControl

Flickable {
    id: root

    HeatingC { id: heatingControl }

    property real roomTemp: heatingControl.temperatures["room"]
    property real releaseTemp: heatingControl.temperatures["release"]
    property real returnTemp: heatingControl.temperatures["return"]
    property real dialsLeftMargin: (dialsContainer.width
                                    - roomTempDial.width
                                    - releaseTempDial.width
                                    - returnTempDial.width) / 2

    property bool heater1On: heatingControl.relays["heater_1"]
    property bool heater2On: heatingControl.relays["heater_2"]
    property bool pumpOn: heatingControl.relays["pump"]
    property real statusLeftMargin: (statusContainer.width
                                     - heater1Status.width
                                     - heater2Status.width
                                     - pumpStatus.width) / 2


    Component.onCompleted: {
        for (var i = 0; i < heatingControl.temperatureHistory.length; ++i)
            temperatureHistorySeries.append(i, heatingControl.temperatureHistory[i])

        for (let i = 0; i < heatingControl.consumptionHistory.length; ++i)
            consumptionHistorySeries.append(i, heatingControl.consumptionHistory[i])
    }

    clip: true
    anchors.fill: parent

    contentWidth: parent.width
    contentHeight: temperaturesLabel.height
                   + dialsContainer.height
                   + heaterPumpLabel.height
                   + statusContainer.height
                   + temperatureHistoryLabel.height
                   + temperatureHistoryChart.height
                   + consumptionHistoryLabel.height
                   + consumptionHistoryChart.height
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

    // Temperature history chart
    ChartView {
        id: temperatureHistoryChart
        width: parent.width * 3 / 4
        height: width * 9 / 16

        anchors {
            top: temperatureHistoryLabel.bottom
            horizontalCenter: parent.horizontalCenter

            topMargin: 32
        }

        axes: [
            ValueAxis{
                id: xAxisTemperatureHistory
                min: 0
                max: heatingControl.temperatureHistory.length
                labelFormat: "%.0f"
                titleText: "Time [period]"
            },
            ValueAxis{
                id: yAxisTemperatureHistory
                min: Math.min(...heatingControl.temperatureHistory) - 5
                max: Math.max(...heatingControl.temperatureHistory) + 5
                labelFormat: "%.0f"
                titleText: "Temperature [°C]"
            }
        ]

        SplineSeries {
            id: temperatureHistorySeries
            axisX: xAxisTemperatureHistory
            axisY: yAxisTemperatureHistory
            name: "Room temperature"
            width: 1
        }
    }

    // Consumption history label
    Label {
        id: consumptionHistoryLabel
        text: "Consumption history"
        font.pixelSize: 28

        anchors {
            top: temperatureHistoryChart.bottom
            left: parent.left
            topMargin: 32
            leftMargin: 32
        }
    }

    ChartView {
        id: consumptionHistoryChart
        width: parent.width * 3 / 4
        height: width * 9 / 16

        anchors {
            top: consumptionHistoryLabel.bottom
            horizontalCenter: parent.horizontalCenter

            topMargin: 32
        }

        axes: [
            ValueAxis{
                id: xAxisConsumptionHistory
                min: 0
                max: heatingControl.consumptionHistory.length
                labelFormat: "%.0f"
                titleText: "Time [period]"
            },
            ValueAxis{
                id: yAxisConsumptionHistory
                min: Math.min(...heatingControl.consumptionHistory) - 200
                max: Math.max(...heatingControl.consumptionHistory) + 200
                labelFormat: "%.0f"
                titleText: "Power [W]"
            }
        ]

        SplineSeries {
            id: consumptionHistorySeries
            axisX: xAxisConsumptionHistory
            axisY: yAxisConsumptionHistory
            name: "Energy consumption"
            width: 1
        }
    }
}
