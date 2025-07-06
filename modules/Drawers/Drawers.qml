import Quickshell
import QtQuick
import QtQuick.Effects
import Quickshell.Hyprland
import "../Bar"

Variants {
    model: Quickshell.screens
    id: root
    PanelWindow {
        id: panelWindow
        property var modelData
        property PopupWindow openedPopup
        screen: modelData
        anchors {
            top: true
            left: true
            right: true
        }
        color: "#252525"
        implicitHeight: 40
        
        Bar{}
        HyprlandFocusGrab {
            id: focusGrab
            windows: [panelWindow, panelWindow.openedPopup]
            active: false
            onActiveChanged: {
                console.log("Focus changed");
                if(!active) {
                    panelWindow.openedPopup.visible = false; // Close the popup when focus is lost
                    panelWindow.openedPopup = null; // Clear the reference to the popup
                }
            }
        }
    }
}