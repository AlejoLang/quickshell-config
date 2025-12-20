pragma ComponentBehavior: Bound
import QtQuick
import qs.services

Item {
  id: root
  implicitWidth: networkIcon.width
  implicitHeight: networkIcon.height
  Text {
    id: networkIcon
    text: NetworkManager.getActiveNetworkStrenghtIcon()
    font.family: "Material Symbols Rounded"
    font.pixelSize: 24
    anchors.verticalCenter: parent.verticalCenter
  }
}