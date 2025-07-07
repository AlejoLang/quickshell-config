import QtQuick
import Quickshell
import "root:/services/"
import "./popup"

Row {
    spacing: 0
    Text {
        id: batteryIcon
        font.family: "Material Symbols Rounded"
        font.pixelSize: 24
        color: "white"
        text: Battery.getBatteryIcon()
        anchors.verticalCenter: parent.verticalCenter 
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onHoveredChanged: {
                if (batteryPopup.visible) {
                    batteryPopup.visible = false;
                    panelWindow.openedPopup = null; 
                } else {
                    batteryPopup.visible = true;
                    panelWindow.openedPopup = batteryPopup;
                }
            }
        }
    }
    Text {
        id: batteryPercentage
        text: Battery.getBatteryPercentage() + "%"
        font.pixelSize: 16
        color: "white"
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onHoveredChanged: {
                if (batteryPopup.visible) {
                    batteryPopup.visible = false;
                    panelWindow.openedPopup = null; 
                } else {
                    batteryPopup.visible = true;
                    panelWindow.openedPopup = batteryPopup;
                }
            }
        }
    }
    BatteryPopup {
        id: batteryPopup
        visible: false
    }
}