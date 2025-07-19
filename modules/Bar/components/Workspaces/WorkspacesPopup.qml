pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import "root:/services/" as Services
import "../../../general"

Rectangle {
    id: root
    property ShellScreen screen
    property real scaleFactor: (clamp((screen.width - 400)/Services.Hyprland.workspacesTopLevels.length, 100, 400)/screen.width).toFixed(2);
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
            model: Services.Hyprland.workspacesTopLevels
            Rectangle {
                required property var modelData
                radius: 5
                
                color: "#d1d1d1"
                width: root.screen.width * root.scaleFactor
                height: root.screen.height * root.scaleFactor
                border.width: modelData.workspace.active ? 2 : 0
                
                Repeater {
                    model: parent.modelData.topLevels
                    Rectangle {
                        required property var modelData
                        color: "#566caa"
                        radius: 5
                        
                        x: modelData.x * root.scaleFactor
                        y: modelData.y * root.scaleFactor
                        width: modelData.width * root.scaleFactor
                        height: modelData.height * root.scaleFactor

                        ScreencopyView {
                            captureSource: parent.modelData.wayland
                            anchors.fill: parent
                            live: false
                            Timer {
                                interval: 10000
                                running: true
                                repeat: true
                                onTriggered: {
                                    parent.captureFrame();
                                }
                            }
                        } 

                        border.width: 2;
                        border.color: "#5e5e5e"
                        
                        MouseArea {
                            anchors.fill: parent
                            propagateComposedEvents: true
                            onClicked: (event) => {
                                Services.Hyprland.dispatch(`focuswindow address:0x${parent.modelData.address}`);
                                workspaces.popupVisible = false; // Hide the popup after focusing
                                event.accepted = false;
                            }
                        }
                        DefaultButton {
                            text: "close"
                            background_color: "#252525"
                            x: parent.width - 10 - width
                            y: 10 
                            visible: Math.min(parent.width - 10 - width, parent.height - 20) > 30
                            width: 32
                            height: 32
                            onClicked: {
                                Services.Hyprland.dispatch(`closewindow address:0x${parent.modelData.address}`);
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
