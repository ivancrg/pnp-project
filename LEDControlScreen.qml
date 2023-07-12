import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import LEDControl

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
    property string activeEffectName: ledControl.currentEffect;
    property string activeEffectColor: ledControl.currentColor;
    property string buttonFontColor: Material.theme === Material.Dark ? "#ffffff" : "#000000"    

    LEDC { id: ledControl }

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

            presetColor: {ledControl.presetColors[0] !== undefined ? ledControl.presetColors[0] : "#000000"}
            presetEffect: {ledControl.presetEffects[0] !== undefined ? ledControl.presetEffects[0] : "question_mark"}

            anchors {
                top: parent.top
                left: parent.left
            }

            onSelectedEffectChanged: ledControl.changePreset(0, selectedEffect, selectedColor)
            onSelectedColorChanged: ledControl.changePreset(0, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                ledControl.setActivePreset(0);
                ledControl.setShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset2

            presetColor: {ledControl.presetColors[1] !== undefined ? ledControl.presetColors[1] : "#000000"}
            presetEffect: {ledControl.presetEffects[1] !== undefined ? ledControl.presetEffects[1] : "question_mark"}

            anchors {
                top: parent.top
                left: preset1.right

                leftMargin: 8
            }

            onSelectedEffectChanged: ledControl.changePreset(1, selectedEffect, selectedColor)
            onSelectedColorChanged: ledControl.changePreset(1, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                ledControl.setActivePreset(1);
                ledControl.setShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset3

            presetColor: {ledControl.presetColors[2] !== undefined ? ledControl.presetColors[2] : "#000000"}
            presetEffect: {ledControl.presetEffects[2] !== undefined ? ledControl.presetEffects[2] : "question_mark"}

            anchors {
                top: parent.top
                left: preset2.right

                leftMargin: 8
            }

            onSelectedEffectChanged: ledControl.changePreset(2, selectedEffect, selectedColor)
            onSelectedColorChanged: ledControl.changePreset(2, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                ledControl.setActivePreset(2);
                ledControl.setShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset4

            presetColor: {ledControl.presetColors[3] !== undefined ? ledControl.presetColors[3] : "#000000"}
            presetEffect: {ledControl.presetEffects[3] !== undefined ? ledControl.presetEffects[3] : "question_mark"}

            anchors {
                top: parent.top
                left: preset3.right

                leftMargin: 8
            }

            onSelectedEffectChanged: ledControl.changePreset(3, selectedEffect, selectedColor)
            onSelectedColorChanged: ledControl.changePreset(3, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                ledControl.setActivePreset(3);
                ledControl.setShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset5

            presetColor: {ledControl.presetColors[4] !== undefined ? ledControl.presetColors[4] : "#000000"}
            presetEffect: {ledControl.presetEffects[4] !== undefined ? ledControl.presetEffects[4] : "question_mark"}

            anchors {
                top: parent.top
                left: preset4.right

                leftMargin: 8
            }

            onSelectedEffectChanged: ledControl.changePreset(4, selectedEffect, selectedColor)
            onSelectedColorChanged: ledControl.changePreset(4, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                ledControl.setActivePreset(4);
                ledControl.setShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset6

            presetColor: {ledControl.presetColors[5] !== undefined ? ledControl.presetColors[5] : "#000000"}
            presetEffect: {ledControl.presetEffects[5] !== undefined ? ledControl.presetEffects[5] : "question_mark"}

            anchors {
                top: parent.top
                left: preset5.right

                leftMargin: 8
            }

            onSelectedEffectChanged: ledControl.changePreset(5, selectedEffect, selectedColor)
            onSelectedColorChanged: ledControl.changePreset(5, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                ledControl.setActivePreset(5);
                ledControl.setShowCurrentEffect(false);
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

            onEffectClicked: ledControl.setCurrentEffect("static")
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

            onEffectClicked: ledControl.setCurrentEffect("pulse")
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

            onEffectClicked: ledControl.setCurrentEffect("flash")
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

            onEffectClicked: ledControl.setCurrentEffect("double_flash")
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

            onEffectClicked: ledControl.setCurrentEffect("cycle")
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

            onEffectClicked: ledControl.setCurrentEffect("wave")
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

            onEffectClicked: ledControl.setCurrentEffect("off")
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

        onActiveColorChanged: ledControl.setCurrentColor(activeColor)

        visible: activeEffectName !== "cycle" && activeEffectName !== "off"
    }

    EffectPreview {
        id: effectPreview
        effectColor: activeEffectColor
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
        text: "Show Effect"
        font.pixelSize: 16

        icon.color: Material.color(Material.Teal)
        icon.source: "qrc:/icons/check.svg"

        Material.foreground: buttonFontColor

        anchors {
            top: effectPreview.visible ? effectPreview.bottom : effects.bottom
            horizontalCenter: effects.horizontalCenter

            topMargin: 24
        }

        onClicked: ledControl.setShowCurrentEffect(true);
    }
}
