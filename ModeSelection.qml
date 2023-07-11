import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls.Material

Item {
    id: root

    property string activeMode: customModeName
    property string customModeName: "custom_mode"
    property string rapidModeName: "rapid_mode"
    property string autoModeName: "auto_mode"

    property string mode1Color: "#00ff0000"
    property string mode2Color: "#0000ff00"
    property string mode3Color: "#000000ff"
    property string mode1BorderColor: Material.accentColor
    property real mode1BorderWidth: customModeName == activeMode ? 3 : 2
    property string mode2BorderColor: Material.accentColor
    property real mode2BorderWidth: rapidModeName == activeMode ? 3 : 2
    property string mode3BorderColor: Material.accentColor
    property real mode3BorderWidth: autoModeName == activeMode ? 3 : 2

    property real modeMargin: 16

    signal customModeClicked
    signal rapidModeClicked
    signal autoModeClicked

    Rectangle {
        id: mode1Container
        width: root.width / 3 - modeMargin
        height: root.height
        color: root.mode1Color
        border.color: mode1BorderColor
        border.width: mode1BorderWidth
        radius: 10

        anchors {
            left: parent.left
            top: parent.top

            leftMargin: modeMargin / 2
        }

        Text {
            id: mode1
            text: "Custom"
            anchors.centerIn: parent
            font.pixelSize: Math.min(14, parent.height - padding * 2)
            font.bold: customModeName == activeMode
            color: customModeName == activeMode ? Material.accentColor : Material.hintTextColor
            padding: 4
        }

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            onClicked: {
                customModeClicked()
                activeMode = customModeName
            }
        }
    }

    Rectangle {
        id: mode2Container
        width: root.width / 3 - modeMargin
        height: root.height
        color: root.mode2Color
        border.color: mode2BorderColor
        border.width: mode2BorderWidth
        radius: 10

        anchors {
            left: mode1Container.right
            top: parent.top

            leftMargin: modeMargin
        }

        Text {
            id: mode2
            text: "Rapid"
            anchors.centerIn: parent
            font.bold: rapidModeName == activeMode
            font.pixelSize: Math.min(14, parent.height - padding * 2)
            color: rapidModeName == activeMode ? Material.accentColor : Material.hintTextColor
            padding: 4
        }

        MouseArea {
            id: mouseArea2
            anchors.fill: parent
            onClicked: {
                rapidModeClicked()
                activeMode = rapidModeName
            }
        }
    }

    Rectangle {
        id: mode3Container
        width: root.width / 3 - modeMargin
        height: root.height
        color: root.mode3Color
        border.color: mode3BorderColor
        border.width: mode3BorderWidth
        radius: 10

        anchors {
            left: mode2Container.right
            top: parent.top

            leftMargin: modeMargin
        }

        Text {
            id: mode3
            text: "Auto"
            anchors.centerIn: parent
            font.bold: autoModeName == activeMode
            font.pixelSize: Math.min(14, parent.height - padding * 2)
            color: autoModeName == activeMode ? Material.accentColor : Material.hintTextColor
            padding: 4
        }

        MouseArea {
            id: mouseArea3
            anchors.fill: parent
            onClicked: {
                autoModeClicked()
                activeMode = autoModeName
            }
        }
    }
}
