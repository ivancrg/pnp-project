import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
//import LEDControl

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
    property string activeEffectName: LEDC.currentEffect;
    property string activeEffectColor: LEDC.currentColor;
    property string buttonFontColor: Material.theme === Material.Dark ? "#ffffff" : "#000000"
    property string activePort: ArduinoComm.selectedPort

    onActivePortChanged: LEDC.pullArduinoParameters()

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

        onClicked: LEDC.pullArduinoParameters()
    }

//    LEDC { id: ledControl }

    // Presets label
    Label {
        id: presetsLabel
        text: "Presets"
        font.pixelSize: 28

        anchors {
            top: parent.top
            left: parent.left
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

            presetColor: {LEDC.presetColors[0] !== undefined ? LEDC.presetColors[0] : "#000000"}
            presetEffect: {LEDC.presetEffects[0] !== undefined ? LEDC.presetEffects[0] : "question_mark"}

            anchors {
                top: parent.top
                left: parent.left
            }

            onSelectedEffectChanged: LEDC.changePreset(0, selectedEffect, selectedColor)
            onSelectedColorChanged: LEDC.changePreset(0, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                LEDC.updateActivePreset(0);
                LEDC.updateShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset2

            presetColor: {LEDC.presetColors[1] !== undefined ? LEDC.presetColors[1] : "#000000"}
            presetEffect: {LEDC.presetEffects[1] !== undefined ? LEDC.presetEffects[1] : "question_mark"}

            anchors {
                top: parent.top
                left: preset1.right

                leftMargin: 8
            }

            onSelectedEffectChanged: LEDC.changePreset(1, selectedEffect, selectedColor)
            onSelectedColorChanged: LEDC.changePreset(1, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                LEDC.updateActivePreset(1);
                LEDC.updateShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset3

            presetColor: {LEDC.presetColors[2] !== undefined ? LEDC.presetColors[2] : "#000000"}
            presetEffect: {LEDC.presetEffects[2] !== undefined ? LEDC.presetEffects[2] : "question_mark"}

            anchors {
                top: parent.top
                left: preset2.right

                leftMargin: 8
            }

            onSelectedEffectChanged: LEDC.changePreset(2, selectedEffect, selectedColor)
            onSelectedColorChanged: LEDC.changePreset(2, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                LEDC.updateActivePreset(2);
                LEDC.updateShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset4

            presetColor: {LEDC.presetColors[3] !== undefined ? LEDC.presetColors[3] : "#000000"}
            presetEffect: {LEDC.presetEffects[3] !== undefined ? LEDC.presetEffects[3] : "question_mark"}

            anchors {
                top: parent.top
                left: preset3.right

                leftMargin: 8
            }

            onSelectedEffectChanged: LEDC.changePreset(3, selectedEffect, selectedColor)
            onSelectedColorChanged: LEDC.changePreset(3, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                LEDC.updateActivePreset(3);
                LEDC.updateShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset5

            presetColor: {LEDC.presetColors[4] !== undefined ? LEDC.presetColors[4] : "#000000"}
            presetEffect: {LEDC.presetEffects[4] !== undefined ? LEDC.presetEffects[4] : "question_mark"}

            anchors {
                top: parent.top
                left: preset4.right

                leftMargin: 8
            }

            onSelectedEffectChanged: LEDC.changePreset(4, selectedEffect, selectedColor)
            onSelectedColorChanged: LEDC.changePreset(4, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                LEDC.updateActivePreset(4);
                LEDC.updateShowCurrentEffect(false);
            }
        }

        Preset {
            id: preset6

            presetColor: {LEDC.presetColors[5] !== undefined ? LEDC.presetColors[5] : "#000000"}
            presetEffect: {LEDC.presetEffects[5] !== undefined ? LEDC.presetEffects[5] : "question_mark"}

            anchors {
                top: parent.top
                left: preset5.right

                leftMargin: 8
            }

            onSelectedEffectChanged: LEDC.changePreset(5, selectedEffect, selectedColor)
            onSelectedColorChanged: LEDC.changePreset(5, selectedEffect, selectedColor)
            onPresetPressAndHold: {
                LEDC.updateActivePreset(5);
                LEDC.updateShowCurrentEffect(false);
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
            effectIconSource: "qrc:/icons/s.svg"
            effectNameText: "Static"

            anchors {
                top: parent.top
                left: parent.left
            }

            onEffectClicked: LEDC.updateCurrentEffect("s")
        }

        Effect {
            id: pulseEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/p.svg"
            effectNameText: "Pulse"

            anchors {
                top: parent.top
                left: staticEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: LEDC.updateCurrentEffect("p")
        }

        Effect {
            id: flashEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/f.svg"
            effectNameText: "Flash"

            anchors {
                top: parent.top
                left: pulseEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: LEDC.updateCurrentEffect("f")
        }

        Effect {
            id: doubleFlashEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/df.svg"
            effectNameText: "Double flash"

            anchors {
                top: parent.top
                left: flashEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: LEDC.updateCurrentEffect("df")
        }

        Effect {
            id: cycleEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/c.svg"
            effectNameText: "Cycle"

            anchors {
                top: parent.top
                left: doubleFlashEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: LEDC.updateCurrentEffect("c")
        }

        Effect {
            id: waveEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/w.svg"
            effectNameText: "Wave"

            anchors {
                top: parent.top
                left: cycleEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: LEDC.updateCurrentEffect("w")
        }

        Effect {
            id: offEffect

            effectIconWidth: 96
            effectIconHeight: 96
            effectIconSource: "qrc:/icons/o.svg"
            effectNameText: "Off"

            anchors {
                top: parent.top
                left: waveEffect.right

                leftMargin: effectsHorizontalMargin
            }

            onEffectClicked: LEDC.updateCurrentEffect("o")
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

        onActiveColorChanged: activeColor !== LEDC.currentColor ? LEDC.updateCurrentColor(activeColor) : 0

        visible: activeEffectName !== "c" && activeEffectName !== "o"
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

        visible: activeEffectName !== "o"
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

        onClicked: LEDC.updateShowCurrentEffect(true);
    }
}
