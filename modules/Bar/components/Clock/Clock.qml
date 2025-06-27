import QtQuick
// qmllint disable import
import "root:/services/"

Column {
    Text {
        id: clockIcon
        font.family: "Material Symbols Rounded"
        font.pixelSize: 24
        textFormat: Text.StyledText
        text: "calendar_month"
        anchors.verticalCenter: parent.verticalCenter
    }
    Text {
        // qmllint disable unqualified
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: clockIcon.right
        anchors.leftMargin: 2
        text: Time.time
        font.pixelSize: 18
        font.family: "CaskaydiaCove Nerd Font"
    }
}