pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import qs.modules.Widgets
import qs.modules.Bar

Item {
  id: root
  width: workspacesRow.width
  height: workspacesRow.height
  property Popup mainPopup
   MouseArea {
      anchors.fill: parent
      propagateComposedEvents: true
      acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton
      onClicked: (event) => {
        if(event.button == Qt.MiddleButton) {
          if(root.mainPopup.content == workspacesPopup) {
            root.mainPopup.close();
            return;
          }
          root.mainPopup.setContent(workspacesPopup, root);
        }
        event.accepted = false;
      }
    } 
  Row {
    id: workspacesRow
    spacing: 5
    Repeater {
      model: Hyprland.workspaces
      MaterialToggleButton {
        required property var modelData
        autoToggle: false
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
 
  WorkspacesPopup {
    id: workspacesPopup
    visible: false
    mainPopup: root.mainPopup
  }
}