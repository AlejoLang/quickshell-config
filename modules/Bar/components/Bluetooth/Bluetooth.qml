import QtQuick
import "root:/services/" as Services
import "../"

Item {
    id: root
    width: bluetoothIcon.width
    height: parent.height
    Text{
        id: bluetoothIcon
        font.family: "Material Symbols Rounded"
        font.pixelSize: 24
        color: "#252525"
        text: Services.Bluetooth.powered ? (Services.Bluetooth.connected ? "bluetooth_connected" : "bluetooth") : "bluetooth_disabled"
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            if(popup.visible && popup.content === bluetoothPopup) {
                return;
            }
            popup.changeContent(root.bluetoothPopup);
            popup.open();
        }
    }

    property PopupContent bluetoothPopup: PopupContent {
        id: bluetoothPopup
        owner: root
        window: root.bar
        width: bluetoothPopupContent.width
        height: bluetoothPopupContent.height
        BluetoothPopup {
            id: bluetoothPopupContent
        }
    }
}