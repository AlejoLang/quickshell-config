import QtQuick
// qmllint disable import
import "root:/services/"

Row {
    spacing: 5
    rightPadding: 4 // Adjust because on the other end there is an icon
    Text {
        id: clockIcon
        font.family: "Material Symbols Rounded"
        font.pixelSize: 24
        color: "#252525"
        text: "calendar_month"
        anchors.verticalCenter: parent.verticalCenter
    }
    Text {
        id: clockText
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0.5 
        text: Time.time
        font.pixelSize: 16
        font.family: "CaskaydiaCove Nerd Font"
        color: "#252525"
    }
}