pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Widgets
import Quickshell
import qs.services

Item {
  id: root
  implicitWidth: cwRow.width
  implicitHeight: cwRow.height
  Row {
    id: cwRow
    spacing: 5
    anchors.verticalCenter: parent.verticalCenter
    IconImage {
      source: Hyprland?.activeClient ? Quickshell.iconPath(Hyprland.activeClient.icon) : ""
      implicitSize: 24
      anchors.verticalCenter: parent.verticalCenter
    }
    Text {
      text: Hyprland?.activeClient?.name ?? "Background"
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}