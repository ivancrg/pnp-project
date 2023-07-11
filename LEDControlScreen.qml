import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Item {
    property real effectsHorizontalMargin: (width
                                            - staticEffect.width
                                            - flashEffect.width
                                            - doubleFlashEffect.width
                                            - cycleEffect.width
                                            - pulseEffect.width
                                            - waveEffect.width
                                            - offEffect.width
                                            - 48) / 7
    property string activeEffectName: "static"  // Set from arduino
    property string activeEffectColor: "#007777" // Set from arduino
    property string buttonFontColor: Material.theme === Material.Dark ? "#ffffff" : "#000000"

    // Presets label
    Label {
        id: presetsLabel
        text: "Presets"
        font.pixelSize: 28

        anchors {
            top: parent.top
            left: parent.left
            topMargin: 48
            leftMargin: 32
        }
    }

    // Presets
    Rectangle {
        id: presets
        width: childrenRect.width
        height: childrenRect.height
        color: "#00000000"

        anchors {
            top: presetsLabel.bottom
            left: parent.left

            margins: 16
            leftMargin: 48
        }

        Preset {
            id: preset1

            presetColor: "#ff0000" // Set from arduino
            presetEffect: "double_flash" // Set from arduino

            anchors {
                top: parent.top
                left: parent.left
            }

            onPresetColorChanged: {
                console.log("Send info to arduino about current effect 1")
            }

            onPresetEffectChanged: {
                console.log("Send info to arduino about current effect 1")
            }
        }

        Preset {
            id: preset2

            presetColor: "#0000ff"

            anchors {
                top: parent.top
                left: preset1.right

                leftMargin: 8
            }

            onPresetColorChanged: {
                console.log("Send info to arduino about current effect 2")
            }

            onPresetEffectChanged: {
                console.log("Send info to arduino about current effect 2")
            }
        }

        Preset {
            id: preset3

            presetColor: "#00ff00"

            anchors {
                top: parent.top
                left: preset2.right

                leftMargin: 8
            }

            onPresetColorChanged: {
                console.log("Send info to arduino about current effect 3")
            }

            onPresetEffectChanged: {
                console.log("Send info to arduino about current effect 3")
            }
        }

        Preset {
            id: preset4

            presetColor: "#ffff00"

            anchors {
                top: parent.top
                left: preset3.right

                leftMargin: 8
            }

            onPresetColorChanged: {
                console.log("Send info to arduino about current effect 4")
            }

            onPresetEffectChanged: {
                console.log("Send info to arduino about current effect 4")
            }
        }

        Preset {
            id: preset5

            presetColor: "#00ffff"

            anchors {
                top: parent.top
                left: preset4.right

                leftMargin: 8
            }

            onPresetColorChanged: {
                console.log("Send info to arduino about current effect 5")
            }

            onPresetEffectChanged: {
                console.log("Send info to arduino about current effect 5")
            }
        }

        Preset {
            id: preset6

            presetColor: "#ff00ff"

            anchors {
                top: parent.top
                left: preset5.right

                leftMargin: 8
            }

            onPresetColorChanged: {
                console.log("Send info to arduino about current effect 6")
            }

            onPresetEffectChanged: {
                console.log("Send info to arduino about current effect 6")
            }
        }
    }

    // Effects label
    Label {
        id: effectsLabel
        text: "Effects"
        font.pixelSize: 28

        anchors {
            top: presets.bottom
            left: parent.left
            topMargin: 32
            leftMargin: 32
        }
    }

    // Effects
    Rectangle {
        id: effects
        width: childrenRect.width
        height: childrenRect.height
        color: "#00000000"

        anchors {
            top: effectsLabel.bottom
            left: parent.left

            margins: 16
            leftMargin: 48
        }

        Effect {
            id: staticEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/static.svg"
            effectNameText: "Static"

            anchors {
                top: parent.top
                left: parent.left
            }

            onEffectClicked: activeEffectName = "static"
        }

        Effect {
            id: pulseEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/pulse.svg"
            effectNameText: "Pulse"

            anchors {
                top: parent.top
                left: staticEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: activeEffectName = "pulse"
        }

        Effect {
            id: flashEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/flash.svg"
            effectNameText: "Flash"

            anchors {
                top: parent.top
                left: pulseEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: activeEffectName = "flash"
        }

        Effect {
            id: doubleFlashEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/double_flash.svg"
            effectNameText: "Double flash"

            anchors {
                top: parent.top
                left: flashEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: activeEffectName = "double_flash"
        }

        Effect {
            id: cycleEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/cycle.svg"
            effectNameText: "Cycle"

            anchors {
                top: parent.top
                left: doubleFlashEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: activeEffectName = "cycle"
        }

        Effect {
            id: waveEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/wave.svg"
            effectNameText: "Wave"

            anchors {
                top: parent.top
                left: cycleEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: activeEffectName = "wave"
        }

        Effect {
            id: offEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/lightbulb_off.svg"
            effectNameText: "Off"

            anchors {
                top: parent.top
                left: waveEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: activeEffectName = "off"
        }
    }

    EffectColorArea {
        id: effectColorPicker
        activeColor: activeEffectColor
        height: 35
        anchors {
            top: effects.bottom
            left: effects.left
            right: effects.right

            topMargin: 12
        }

        visible: activeEffectName !== "cycle" && activeEffectName !== "off"
    }

    EffectPreview {
        id: effectPreview
        effectColor: effectColorPicker.activeColor
        effectName: activeEffectName
        height: 75
        width: 75
        anchors {
            top: effectColorPicker.visible ? effectColorPicker.bottom : effects.bottom
            horizontalCenter: effects.horizontalCenter

            topMargin: 24
        }

        visible: activeEffectName !== "off"
    }

    Button {
        id: confirmEffect
        text: "Confirm"
        font.pixelSize: 16

        icon.color: Material.color(Material.Teal)
        icon.source: "qrc:/icons/check.svg"

        Material.foreground: buttonFontColor

        anchors {
            top: effectPreview.visible ? effectPreview.bottom : effects.bottom
            horizontalCenter: effects.horizontalCenter

            topMargin: 24
        }

        onClicked: {
            console.log("Send info to arduino about current effect")
        }
    }
}
