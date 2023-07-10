import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Rectangle {
    signal effectClicked

    id: root

    property real effectIconWidth: 24
    property real effectIconHeight: 24
    property string effectIconSource: "qrc:/icons/question_mark.svg"
    property string effectIconColor: Material.color(Material.Teal)
    property string effectNameText: "Effect ?"
    property string effectBackgroundColor: "#00000000"
    property real borderRadius: 0
    property real borderWidth: 0
    property string borderColor: "00000000"

    radius: borderRadius
    border.width: borderWidth
    border.color: borderColor

    color: effectBackgroundColor

    width: (effectIcon.width > effectName.width ? effectIcon.width : effectName.width) + borderWidth * 2
    height: effectIcon.height + effectName.height + 8 * 2 + borderWidth * 2

    CustomIcon {
        id: effectIcon
        iconWidth: root.effectIconWidth
        iconHeight: root.effectIconHeight
        iconSource: root.effectIconSource
        iconColor: root.effectIconColor

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter

            topMargin: borderWidth
        }
    }

    Label {
        id: effectName
        text: root.effectNameText
        font.pixelSize: 14
        font.bold: false

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: effectIcon.bottom

            margins: 8
        }
    }

    MouseArea {
        anchors.fill: effectIcon

        onClicked: {root.effectClicked()}
    }
}
