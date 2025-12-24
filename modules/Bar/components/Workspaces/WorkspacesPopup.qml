pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.modules.Bar

Item {
  id: root
  property real windowScaling: 0.08
  property ShellScreen screen: Quickshell?.screens[0] ?? null
  property Popup mainPopup
  width: workspacesRow.width
  height: workspacesRow.height
  Row {
    id: workspacesRow
    width: childrenRect.width
    height: childrenRect.height
    spacing: 10
    Repeater {
      model: Hyprland.workspacesTopLevels
      Rectangle {
        required property Hyprland.WorkspaceClients modelData
        id: workspaceItem
        width: (root.screen ? root.screen.width : 1920) * root.windowScaling + 10
        height: (root.screen ? root.screen.height : 1920) * root.windowScaling + 10
        radius: 10
        border.color: modelData.workspace.active ? "#34afaf" : "#202020"
        border.width: 4
        Repeater {
          model: workspaceItem.modelData.topLevels
          Rectangle {
            required property Hyprland.CustomHyprlandTopLevel modelData
            width: modelData.width * root.windowScaling
            height: modelData.height * root.windowScaling
            x: modelData.x * root.windowScaling + 5
            y: modelData.y * root.windowScaling + 5
            color: "#343434"
            radius: 4
            IconImage {
              source: Quickshell.iconPath(parent.modelData.icon)
              width: parent.width > 10 ? parent.width * 0.3 : 0
              height: width
              anchors.centerIn: parent
            }
            MouseArea {
              anchors.fill: parent
              onClicked: {
                Hyprland.dispatch("focuswindow address:" + parent.modelData.address)
               root.mainPopup.close()
              }
            }
          }
        }
      }
    }  
  }
}