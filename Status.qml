import QtQuick
import QtQuick.Controls.Material

Item {
    id: root

    property real textLabelMargin: 8
    property string labelText: "Status"
    property string statusIconSource: "qrc:/icons/question_mark.svg"
    property string statusIconColor: "#ff0000"
    property bool wrapLabel: false

    CustomIcon {
        id: icon

        iconWidth: height
        iconHeight: root.height - statusLabel.height - textLabelMargin
        iconSource: statusIconSource
        iconColor: statusIconColor

        anchors {
            top: root.top
            horizontalCenter: root.horizontalCenter
        }
    }

    Label {
        id: statusLabel
        width: root.width

        text: labelText
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        wrapMode: wrapLabel ? Text.Wrap : Text.NoWrap
        color: Material.primaryTextColor

        anchors {
            horizontalCenter: root.horizontalCenter
            top: icon.bottom

            topMargin: textLabelMargin
        }
    }
}
