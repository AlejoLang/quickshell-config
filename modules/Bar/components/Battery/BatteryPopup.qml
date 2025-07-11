import QtQuick
import "root:/services/" as Services
import Quickshell.Services.UPower

Rectangle {
    id: root
    implicitWidth: batteryPopupColumn.width
    implicitHeight: batteryPopupColumn.height
    color: "#EFEFEF"
    radius: 10
    Column {
        id: batteryPopupColumn
        width: Math.max(batteryPopupStatus.width, batteryPopupTime.width) + 20
        height: batteryPopupColumn.childrenRect.height + 20
        spacing: 4
        padding: 10
        Text {
            id: batteryPopupStatus
            text: Services.Battery.getBatteryState()
            font.bold: true
            font.pixelSize: 16
            font.family: "CaskaydiaCove Nerd Font"
            color: "#252525"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: batteryPopupRate
            text: Math.abs(Services.Battery.getBatteryRate()) + " W"
            font.pixelSize: 14
            font.family: "CaskaydiaCove Nerd Font"
            color: "#252525"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: batteryPopupTime
            text: {
                const timeInSeconds = Services.Battery.getTime();
                const hours = Math.floor(timeInSeconds / 3600);
                const minutes = Math.floor((timeInSeconds % 3600) / 60);
                switch (Services.Battery.battery.state) {
                    case UPowerDeviceState.Charging:
                        return `Time to full: ${hours}h ${minutes}m`;
                    case UPowerDeviceState.Discharging:
                        return `Time to empty: ${hours}h ${minutes}m`;
                    case UPowerDeviceState.FullyCharged:
                        return 'Full';
                    default:
                        return '';
                } 
            }
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}