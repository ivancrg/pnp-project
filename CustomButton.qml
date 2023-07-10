import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Rectangle {
    property string icon_source: "qrc:/icons/question_mark.svg"
    property string button_text: "button_text"
    property real icon_width: buttonIcon.implicitWidth
    property real icon_height: buttonIcon.implicitHeight

    width: buttonIcon.width + buttonText.implicitWidth
    height: buttonIcon.height + buttonText.implicitHeight

    color: Material.color(Material.theme)

    Image {
        id: buttonIcon
        source: icon_source
        width: icon_width
        height: icon_height

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }
    }

    Label {
        id: buttonText
        text: button_text

        anchors {
            verticalCenter: parent.verticalCenter
            left: buttonIcon.right
        }
    }
}
