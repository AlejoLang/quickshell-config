import QtQuick
import Quickshell
import Quickshell.Widgets
import "root:/services/"

Row {
    id: root
    spacing: 5

    IconImage {
        id: windowIcon
        source: Hyprland.activeClient ? Quickshell.iconPath(Hyprland.activeClient.icon) : "qrc:/icons/background.svg"
        implicitSize: 24
        anchors.verticalCenter: parent.verticalCenter
    } 

    Text {
        id: windowName
        text: Hyprland?.activeClient ? Hyprland?.activeClient?.name : "Background"
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0.5
        font.pixelSize: 16
        font.family: "CaskaydiaCove Nerd Font"
        color: "#252525"
    }
}