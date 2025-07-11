import QtQuick
import Quickshell
import Quickshell.Hyprland
import "root:/services/"

Rectangle {
    id: root
    property ShellScreen screen
    property bool popupVisible: false
    implicitHeight: workspacesRow.implicitHeight
    implicitWidth: workspacesRow.implicitWidth
    color: "transparent"
    Row {
        id: workspacesRow
        spacing: 5
        Repeater {
            model: Hyprland.workspaces // Directly use the workspaces model
            Text {
                text: {modelData.active ? "radio_button_checked" : "radio_button_unchecked"}
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
                font.family: "Material Symbols Rounded"
                color: "#252525"
                MouseArea {
                    propagateComposedEvents: true
                    anchors.fill: parent
                    onClicked: (event) => {
                        modelData.activate()    
                        event.accepted = false
                    }
                }
            } 
        }
    }

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton
        onClicked: (event) => {
            if (event.button === Qt.MiddleButton) {
                root.popupVisible = !root.popupVisible; // Toggle popup visibility
            } 
            event.accepted = false
        }
        onWheel: (event) => {
            if (event.angleDelta.y > 0 && Hyprland.focusedWorkspace.id < 10) {
                Hyprland.dispatch("workspace +1");
            } else if (event.angleDelta.y < 0 && Hyprland.focusedWorkspace.id > 1) {
                Hyprland.dispatch("workspace -1");
            }
            console.log(Hyprland.focusedWorkspace.id)
            event.accepted = false; // Prevent further propagation
        }
    }

   PopupWindow {
        id: workspacesSpecialPopup
        anchor.window: drawerWindow 
        anchor.rect.x: (root.screen.width/2) - (workspacesPopup.width/2)
        anchor.rect.y: (root.screen.height/2) - (workspacesPopup.height/2)
        visible: root.popupVisible
        color: "transparent"
        implicitHeight: workspacesPopup.implicitHeight
        implicitWidth: workspacesPopup.implicitWidth
        
        WorkspacesPopup {
            id: workspacesPopup
            screen: root.screen
        }
        
    }

    HyprlandFocusGrab {
            active: root.popupVisible
            windows: [workspacesSpecialPopup]
            onCleared: {
                root.popupVisible = false; // Hide the popup when focus is cleared
            }
        }
}

