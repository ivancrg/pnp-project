import QtQuick
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts

Rectangle {
    /*!
        https://forum.qt.io/post/548434
        Returns true if the color is dark and should have light content on top
    */
    function isDarkColor(background) {
        var temp = Qt.darker(background, 1) //Force conversion to color QML type object
        var a = 1 - ( 0.299 * temp.r + 0.587 * temp.g + 0.114 * temp.b);
        return temp.a > 0 && a >= 0.3
    }

    id: root

    // signal presetClicked
    property string presetColor: "#000000"
    property string selectedColor: presetColor
    property string presetEffect: "s"
    property string selectedEffect: presetEffect
    property string presetEffectIconSource: "qrc:/icons/" + presetEffect + ".svg"
    property real presetWidth: 50
    property real presetHeight: 50

    signal presetPressAndHold

    width: presetWidth
    height: presetHeight

    color: "#00000000"

    Rectangle {
        id: presetColorDisplay

        anchors.fill: parent

        border.width: 0
        border.color: Material.color(Material.teal)
        radius: 5

        color: presetColor
    }

    CustomIcon {
        id: presetEffectDisplay

        iconWidth: root.width * 3/4
        iconHeight: height * 3/4
        iconSource: presetEffectIconSource
        iconColor: isDarkColor(presetColor) ? "#ffffff" : "#000000"

        anchors.centerIn: parent
    }

    Dialog {
        id: effectDialog

        title: "Choose preset effect"
        modal: Qt.ApplicationModal
        width: Math.max(implicitWidth, effectDialogContent.width)
               + (implicitWidth < effectDialogContent.width
                  ? (effectDialogContent.width - implicitWidth) + padding
                  : 0)
        height: implicitHeight + effectDialogContent.height

        contentData: Rectangle {
            id: effectDialogContent

            anchors {
                top: parent.top
                left: parent.left
            }

            width: childrenRect.width
            height: childrenRect.height

            color: "#00000000"

            Effect {
                id: staticEffect
                effectIconSource: "qrc:/icons/s.svg"
                effectNameText: "Static"

                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: 4
                }

                onEffectClicked: {
                    root.selectedEffect = "s"
                    effectDialog.close()
                }
            }

            Effect {
                id: pulseEffect
                effectIconSource: "qrc:/icons/p.svg"
                effectNameText: "Pulse"

                anchors {
                    top: parent.top
                    left: staticEffect.right
                    leftMargin: 4
                }

                onEffectClicked: {
                    root.selectedEffect = "p"
                    effectDialog.close()
                }
            }

            Effect {
                id: flashEffect
                effectIconSource: "qrc:/icons/f.svg"
                effectNameText: "Flash"

                anchors {
                    top: parent.top
                    left: pulseEffect.right
                    leftMargin: 4
                }

                onEffectClicked: {
                    root.selectedEffect = "f"
                    effectDialog.close()
                }
            }

            Effect {
                id: doubleFlashEffect
                effectIconSource: "qrc:/icons/df.svg"
                effectNameText: "Double flash"

                anchors {
                    top: parent.top
                    left: flashEffect.right
                    leftMargin: 4
                }

                onEffectClicked: {
                    root.selectedEffect = "df"
                    effectDialog.close()
                }
            }

            Effect {
                id: cycleEffect
                effectIconSource: "qrc:/icons/c.svg"
                effectNameText: "Cycle"

                anchors {
                    top: parent.top
                    left: doubleFlashEffect.right
                    leftMargin: 4
                }

                onEffectClicked: {
                    root.selectedEffect = "c"
                    effectDialog.close()
                }
            }

            Effect {
                id: waveEffect
                effectIconSource: "qrc:/icons/w.svg"
                effectNameText: "Wave"

                anchors {
                    top: parent.top
                    left: cycleEffect.right
                    leftMargin: 4
                }

                onEffectClicked: {
                    root.selectedEffect = "w"
                    effectDialog.close()
                }
            }

            Effect {
                id: offEffect
                effectIconSource: "qrc:/icons/o.svg"
                effectNameText: "Off"

                anchors {
                    top: parent.top
                    left: waveEffect.right
                    leftMargin: 4
                }

                onEffectClicked: {
                    root.selectedEffect = "o"
                    effectDialog.close()
                }
            }
        }
    }

    ColorDialog {
        id: colorDialog
        selectedColor: presetColor
        onAccepted: root.selectedColor = selectedColor
    }

    MouseArea {
        id: presetMouseArea
        anchors.fill: parent
        // onClicked: presetClicked()
        onClicked: colorDialog.open()
        onDoubleClicked: effectDialog.open()
        pressAndHoldInterval: 500
        onPressAndHold: presetPressAndHold()
    }
}
