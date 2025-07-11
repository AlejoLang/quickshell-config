pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "root:/services/"

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
                
                color: "#8a8a8a"
                width: root.screen.width * root.scaleFactor
                height: root.screen.height * root.scaleFactor
                
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
                    }
                } 
                
            }
        }
    }
}
