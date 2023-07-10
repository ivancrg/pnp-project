import QtQuick
import QtQuick.Dialogs

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

    property string activeColor: "#000000"

    color: activeColor
    radius: 10

    Text {
        id: activeColorLabel
        text: activeColor
        anchors.centerIn: parent
        font.pixelSize: Math.min(14, parent.height - padding * 2)
        color: isDarkColor(activeColor) ? "#ffffff" : "#000000"
        padding: 4
    }

    ColorDialog {
        id: colorDialog
        selectedColor: activeColor
        onAccepted: {activeColor = selectedColor; console.log(selectedColor)}
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: colorDialog.open()
    }
}
