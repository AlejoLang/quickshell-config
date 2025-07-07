import QtQuick
import "root:/services/"

Row {
    Text{
        id: bluetoothIcon
        font.family: "Material Symbols Rounded"
        font.pixelSize: 24
        color: "#252525"
        text: Bluetooth.powered ? (Bluetooth.connected ? "bluetooth_connected" : "bluetooth") : "bluetooth_disabled"
    }
}