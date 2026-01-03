pragma ComponentBehavior: Bound
import QtQuick
import qs.services
import qs.modules.Bar

Item {
  id: root
  property Popup mainPopup
  implicitWidth: blueoothIcon.width
  implicitHeight: blueoothIcon.height
  Text {
    id: blueoothIcon
    text: Bluetooth.powered ? (Bluetooth.connected ? "bluetooth_connected" : "bluetooth") : "bluetooth_disabled"
    font.family: "Material Symbols Rounded"
    font.pixelSize: 24
    anchors.verticalCenter: parent.verticalCenter
  }
  MouseArea {
    anchors.fill: parent
    onClicked: {
      if(root.mainPopup.content == bluetoothPopup) {
        root.mainPopup.close();
        return;
      }
      root.mainPopup.setContent(bluetoothPopup, root);
    }
  }
  BluetoothPopup {
    id: bluetoothPopup
    visible: false
  }
}