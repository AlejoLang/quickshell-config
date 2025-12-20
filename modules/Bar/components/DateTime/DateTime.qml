pragma ComponentBehavior: Bound
import QtQuick
import qs.services

Item {
  width: dateText.width
  height: dateText.height
  Text {
    id: dateText
    anchors.verticalCenter: parent.verticalCenter
    text: Time.time
    font.weight: 700
  }
}