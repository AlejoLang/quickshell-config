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

            Region {
                id: barPopupR
                x: popup.absX - 100 ?? 0
                y: popup.absY - 100 ?? 0
                width: popup.content.width + 200 ?? 0
                height: popup.content.height + 200 ?? 0
                intersection: Intersection.Subtract
            }

            mask: Region {
                x: 8
                y: bar.height
                width: drawerWindow.width - 16
                height: drawerWindow.height - bar.height - 8
                intersection: Intersection.Subtract
                regions: [popup.visible ? barPopupR : null]
            }

            PopupsController {
                id: popupsController
                barPopup: popup
                screen: drawerScope.modelData
                window: drawerWindow
                propagateComposedEvents: true
            }

            Bar{
                id: bar
                barPopups: drawerWindow.popup
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
                popupController: popupsController
            }
        }
    } 
}