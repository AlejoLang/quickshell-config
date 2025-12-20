pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import qs.modules.Widgets

Item {
  id: root
  width: workspacesRow.width
  height: workspacesRow.height
 
  Row {
    id: workspacesRow
    spacing: 5
    Repeater {
      model: Hyprland.workspaces
      MaterialToggleButton {
        required property var modelData
        autoToggle: false
        backgroundActiveColor: '#3d3e74'
        backgroundInactiveColor: "#767676"
        textActiveColor: "#efefef"
        textInactiveColor: "#010101"
        buttonIcon: modelData.id
        statusPressed: Hyprland.focusedMonitor?.activeWorkspace === modelData

        onClicked: {
          if (Hyprland.focusedMonitor?.activeWorkspace !== modelData) {
            modelData.activate()
          }
        }
      }
    }
  }
}