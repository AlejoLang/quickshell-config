import QtQuick
import Quickshell
import Quickshell.Hyprland
import "root:/services/" as Services

Rectangle {
    id: root
    property ShellScreen screen
    property bool popupVisible: false
    height: parent.height
    implicitWidth: workspacesRow.implicitWidth
    color: "transparent"
    Row {
        id: workspacesRow
        height: parent.height
        width: childrenRect.width
        spacing: 5
        anchors.verticalCenter: parent.verticalCenter
        Repeater {
            model: Services.Hyprland.workspaces // Directly use the workspaces model
            Rectangle {
                required property var modelData;
                height: 15;
                width: modelData.active ? 2 * (height) : height;
                color: modelData.active ? "#252525" : "#a3a3a3"
                radius: height / 2;
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: (event) => {
                        if (event.button === Qt.LeftButton) {
                            Services.Hyprland.dispatch("workspace " + parent.modelData.id);
                        } 
                        event.accepted = true;
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

