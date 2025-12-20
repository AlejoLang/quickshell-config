pragma ComponentBehavior: Bound
import QtQuick
import qs.services

Item {
  id: root
  implicitWidth: blueoothIcon.width
  implicitHeight: blueoothIcon.height
  Text {
    id: blueoothIcon
    text: Bluetooth.powered ? (Bluetooth.connected ? "bluetooth_connected" : "bluetooth") : "bluetooth_disabled"
    font.family: "Material Symbols Rounded"
    font.pixelSize: 24
    anchors.verticalCenter: parent.verticalCenter
  }
}