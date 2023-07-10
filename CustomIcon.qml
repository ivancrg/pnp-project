import QtQuick
import QtQuick.Controls

Item {
    property real iconWidth: 24
    property real iconHeight: 24
    property string iconSource: ""
    property string iconColor: "#000000"

    width: iconWidth
    height: iconHeight

    Button {
        anchors.centerIn: parent
        background: Item { }
        icon.source: iconSource
        icon.width: iconWidth
        icon.height: iconHeight
        icon.color: iconColor
        enabled: false
    }
}
