pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "root:/services/"
import "../../../general"

Rectangle {
    id: root
    property ShellScreen screen
    property real scaleFactor: (clamp((screen.width - 400)/Hyprland.workspacesClients.length, 100, 400)/screen.width).toFixed(2);
    color: "#EFEFEF"
    implicitHeight: workspacesRowLayout.height + 20
    implicitWidth: workspacesRowLayout.width + 20
    radius: 10

    function clamp (value, min, max) {
        return Math.max(min, Math.min(max, value));
    }

    RowLayout {
        id: workspacesRowLayout
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        Repeater {
            model: Hyprland.workspacesClients
            Rectangle {
                required property var modelData
                radius: 5
                
                color: "#d1d1d1"
                width: root.screen.width * root.scaleFactor
                height: root.screen.height * root.scaleFactor
                border.width: modelData.workspace.active ? 2 : 0
                
                Repeater {
                    model: parent.modelData.clients
                    Rectangle {
                        required property var modelData
                        color: "#566caa"
                        radius: 5
                        
                        x: modelData.x * root.scaleFactor
                        y: modelData.y * root.scaleFactor
                        width: modelData.width * root.scaleFactor
                        height: modelData.height * root.scaleFactor

                        border.width: 2;
                        border.color: "#5e5e5e"
                        
                        IconImage {
                            source: Quickshell.iconPath(DesktopEntries.applications.values.find(entry => entry.id.toLowerCase() === modelData.initialClass.toLowerCase())?.icon || "unknown")
                            implicitSize: 32
                            anchors.centerIn: parent
                        } 
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: (event) => {
                                Hyprland.dispatch(`focuswindow address:${parent.modelData.address}`);
                                workspaces.popupVisible = false; // Hide the popup after focusing
                                event.accepted = false;
                            }
                        }
                        DefaultButton {
                            text: "close"
                            backgroundColor: "#252525"
                            x: parent.width - 10 - width
                            y: 10 
                            visible: Math.min(parent.width - 10 - width, parent.height - 20) > 30
                            onClicked: {
                                Hyprland.dispatch(`closewindow address:${parent.modelData.address}`);
                                event.accepted = false;
                            }
                        }
                    }
                } 
                
            }
            
        }
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton
        onWheel: (event) => {
            if (event.angleDelta.y > 0 && Hyprland.focusedWorkspace.id < 10) {
                Hyprland.dispatch(`workspace +1`);
            } else if (event.angleDelta.y < 0 && Hyprland.focusedWorkspace.id > 1) {
                Hyprland.dispatch(`workspace -1`);
            }
            event.accepted = false; // Prevent further propagation
        }
    } 
}
