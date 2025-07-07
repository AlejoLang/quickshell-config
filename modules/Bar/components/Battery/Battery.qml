import QtQuick
import Quickshell
import "root:/services/"
import "./popup/"

Rectangle {
    id: root
    implicitWidth: batteryRow.width
    implicitHeight: parent.implicitHeight
    color: "transparent"
    
    Row {
        id: batteryRow
        width: batteryRow.children.reduce((acc, child) => acc + child.width, 0)
        height: children.values.reduce((acc, child) => Math.max(acc, child.height), 0)
        anchors.fill: parent

        Text {
            id: batteryIcon
            font.family: "Material Symbols Rounded"
            font.pixelSize: 24
            color: "#252525"
            text: Battery.getBatteryIcon()
            anchors.verticalCenter: parent.verticalCenter 
        }
        Text {
            id: batteryPercentage
            text: Battery.getBatteryPercentage() + "%"
            font.pixelSize: 16
            font.family: "CaskaydiaCove Nerd Font"
            color: "#252525"
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0.5
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            root.color = "#d6d6d6"
        }
        onExited: {
            root.color = "transparent"
        }
    }
}