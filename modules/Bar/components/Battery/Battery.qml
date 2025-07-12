import QtQuick
import Quickshell
import "root:/services/" as Services
import "../"

Rectangle {
    id: root
    required property var bar
    implicitWidth: batteryRow.width
    implicitHeight: parent.implicitHeight
    color: "transparent"
    
    Row {
        id: batteryRow
        width: batteryIcon.width + batteryPercentage.width + 10
        height: Math.max(batteryIcon.height, batteryPercentage.height)
        anchors.fill: parent
        padding: 5

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
            if (popup && popup.visible) {
                if(popup.content === root.batteryPopup) {
                    return;
                } else {
                    popup.changeContent(root.batteryPopup);
                }
            } else if (popup) {
                popup.changeContent(root.batteryPopup);
                popup.open();
            }
        }
    }

    property PopupContent batteryPopup: PopupContent {
        id: batteryPopup
        owner: root
        window: root.bar
        width: batteryPopupContent.width
        height: batteryPopupContent.height
        BatteryPopup {
            id: batteryPopupContent
        }
    }
}