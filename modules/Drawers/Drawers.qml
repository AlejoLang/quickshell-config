pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../Bar"
import "../Bar/components"

Variants {
    model: Quickshell.screens
    id: root
    Scope {
        id: drawerScope
        required property ShellScreen modelData

        PanelWindow {
            id: drawerWindow
            property PopupContent popup
            property PopupContent hoverPopup
            
            screen: drawerScope.modelData
            exclusionMode: ExclusionMode.Ignore
            color: "transparent"
            
            anchors {
                top: true
                right: true
                bottom: true
                left: true
            }

            Exclusions {
                screen: drawerScope.modelData
                bar: bar
            }

            Borders {
                screen: drawerScope.modelData
                bar: bar
            }

            mask: Region {
                x: 10
                y: bar.implicitHeight
                width: drawerWindow.width - 20
                height: drawerWindow.height - bar.implicitHeight - 10
                intersection: Intersection.Xor
                regions: [barPopupR]
            }

            Region {
                id: barPopupR
                x: popup.absX - 20
                y: popup.absY - 20
                width: popup.visible? popup.content.width + 40: 0
                height: popup.visible ? popup.content.height + 40 : 0
                intersection: Intersection.Subtract
            }
            PopupsController {
                barPopup: popup
                screen: drawerScope.modelData
                window: drawerWindow
            }

            Bar{
                id: bar
                barPopups: drawerWindow.popup
                barHoverPopups: drawerWindow.hoverPopup
                popupObject: popup
                hoverPopupObject: hoverPopup
                screen: drawerScope.modelData
            }
            Popup {
                id: hoverPopup
                window: drawerWindow
                screen: drawerScope.modelData
                content: drawerWindow.hoverPopup
                visible: false
                isHoverPopup: true
            }
            Popup {
                id: popup
                window: drawerWindow
                screen: drawerScope.modelData
                content: drawerWindow.popup
                visible: false
                isHoverPopup: false
            }
        }
    } 
}