import QtQuick
// qmllint disable import
import "root:/services/"

Row {
    spacing: 5
    Text {
        id: clockIcon
        font.family: "Material Symbols Rounded"
        font.pixelSize: 24
        color: "white"
        text: "calendar_month"
        anchors.verticalCenter: parent.verticalCenter
    }
    Text {
        // qmllint disable unqualified
        id: clockText
        anchors.bottom: clockIcon.bottom
        anchors.bottomMargin: 4
        text: Time.time
        font.pixelSize: 16
        font.family: "CaskaydiaCove Nerd Font"
        color: "white"
    }
}