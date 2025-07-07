import QtQuick
import Quickshell
import "root:/services/"

PopupWindow {
    id: batteryPopup
    anchor.window: panelWindow
    anchor.rect.x: panelWindow.itemPosition(batteryWidget).x + (batteryWidget.width / 2) - (batteryPopup.implicitWidth / 2)
    anchor.rect.y: panelWindow.implicitHeight + 10
    implicitWidth: 300
    implicitHeight: rect.height
    visible: false
    color: "transparent"
    Rectangle {
        id: rect
        height: col.height 
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#252525"
        radius: 10
        border.color: "#444444"
        border.width: 3
        Column {
            width: parent.width
            height: batteryCharging.height + popupBatteryPercentage.height + 2*col.padding + col.spacing
            id: col
            spacing: 10
            padding: 10
            Text {
                id: batteryCharging
                text: "Charging: " + (Battery.onBattery() ? "No" : "Yes")
                font.pixelSize: 16
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                id: popupBatteryPercentage
                text: {
                    if (Battery.onBattery()) {
                        const h = (Battery.getTimeToEmpty() / 3600).toFixed(0) ;
                        const m = ((Battery.getTimeToEmpty() % 3600) / 60).toFixed(0);

                        return "Time to empty: " + h + " h " + m + " min ";
                    } else {
                        const h = (Battery.getTimeToFull() / 3600).toFixed(0);
                        const m = ((Battery.getTimeToFull() % 3600) / 60).toFixed(0);
                        return "Time to full: " + h + " h " + m + " min ";
                    }
                } 
                font.pixelSize: 16
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}