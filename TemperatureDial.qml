import QtQuick
import QtQuick.Controls.Material
import "./ColorInterpolation" as CI

Item {
    id: root

    property real dialMinValue: 0
    property real dialMaxValue: 40
    property real initialTemperatureValue: 25.5    // Set with arduino
    property real temperatureValue: Math.round(temperatureDial.value * 10) / 10   // Use for arduino input
    property string labelText: "Dial"
    property real tempFraction: (Math.abs(temperatureDial.from) + temperatureValue) / (temperatureDial.to - temperatureDial.from)
    property bool useTempFraction: true
    property string colorMinTemp: Material.accentColor
    property string colorMaxTemp: "darkred"
    property real labelTextMargin: 8
    property bool wrapLabel: false
    property bool hoverEnabled: false
    property string hoverText: "N/A"

    Text {
        id: temperatureText

        text: temperatureValue + "°C"
        anchors.centerIn: temperatureDial

        font.pixelSize: Math.min(20, Math.max(0, temperatureDial.height - 20))
        font.bold: true

        color: useTempFraction
               ? colorInterpolator.getColorAt(tempFraction)
               : Material.accentColor

        CI.ColorInterpolation {
            id: colorInterpolator

            stops: [
                CI.InterpolationStop { position: 0.0; color: colorMinTemp },
                CI.InterpolationStop { position: 1.0; color: colorMaxTemp }
            ]
        }
    }

    Dial {
        id: temperatureDial

        width: height
        height: root.height - dialLabel.height - labelTextMargin

        from: dialMinValue
        to: dialMaxValue
        value: initialTemperatureValue
        stepSize: 0.1
        snapMode: Dial.SnapAlways
        enabled: root.enabled

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
    }

    Label {
        id: dialLabel
        width: root.width

        text: labelText
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        wrapMode: wrapLabel ? Text.Wrap : Text.NoWrap
        color: Material.primaryTextColor

        anchors {
            horizontalCenter: temperatureDial.horizontalCenter
            top: temperatureDial.bottom

            topMargin: labelTextMargin
        }

        HoverHandler {
            id: hoverHandler
            acceptedDevices: PointerDevice.AllDevices
        }

        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.visible: hoverHandler.hovered && hoverEnabled
        ToolTip.text: hoverText
    }
}
