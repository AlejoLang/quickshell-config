import QtQuick
import Quickshell
import "root:/services/" as Services
import "../"

Rectangle {
    id: root
    implicitWidth: batteryRow.width
    implicitHeight: parent.implicitHeight
    color: "transparent"
    
    Row {
        id: batteryRow
        width: batteryIcon.width + batteryPercentage.width 
        height: Math.max(batteryIcon.height, batteryPercentage.height)
        anchors.fill: parent

        Text {
            id: batteryIcon
            font.family: "Material Symbols Rounded"
            font.pixelSize: 24
            color: "#252525"
            text: Services.Battery.getBatteryIcon()
            anchors.verticalCenter: parent.verticalCenter 
        }
        Text {
            id: batteryPercentage
            text: Services.Battery.getBatteryPercentage() + "%"
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
            if (hoverPopup.visible) {
                if(hoverPopup.content === root.batteryHoverPopup) {
                    hoverPopup.visible = false;
                } else {
                    hoverPopup.changeContent(root.batteryHoverPopup);
                }
            } else {
                hoverPopup.changeContent(root.batteryHoverPopup);
                hoverPopup.visible = true;
            }
        }
        onExited: {
            root.color = "transparent"
            if (hoverPopup.visible) {
                hoverPopup.visible = false;
            }
        }
    }

    property PopupContent batteryHoverPopup: PopupContent {
        id: batteryHoverPopup
        owner: root
        BatteryHoverPopup {

        }
    }
}