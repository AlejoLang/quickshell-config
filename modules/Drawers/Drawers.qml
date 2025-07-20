pragma ComponentBehavior: Bound
import Quickshell
import QtQuick.Effects
import QtQuick
import QtQuick.Shapes
import "../Bar"
import "../Bar/components"
import "../Osd"
import "../Launcher"
import Quickshell.Wayland

Variants {
    model: Quickshell.screens
    id: root
    Scope {
        id: drawerScope
        required property ShellScreen modelData

        PanelWindow {
            id: drawerWindow
            property PopupContent popup
            WlrLayershell.keyboardFocus: launcher.visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
            
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

            Item {
                id: bordersItem
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#000000"
                    blurMax: 30
                }

                Borders {
                    screen: drawerScope.modelData
                    bar: bar
                }
                Shape {
                    visible: popup.visible || osd.visible || launcher.visible
                PopupBackground {
                    id: popupBackground
                    popup: popup
                    startX: popup.absX - 20
                    startY: popup.popupY + bar.height
                    round: 20
                }}
            }

            Region {
                id: barPopupR
                x: popup.absX - 1000 ?? 0
                y: popup.absY - 1000 ?? 0
                width: popup.content?.width + 2000 ?? 0
                height: popup.content?.height + 2000 ?? 0
                intersection: Intersection.Subtract
            }
            Region {
                id: osdR
                x: osd.relativeX - 1000 ?? 0
                y: osd.relativeY - 1000 ?? 0
                width: osd.width + 2000 ?? 0
                height: osd.height + 2000 ?? 0
                intersection: Intersection.Subtract
            }
            Region {
                id: launcherR
                x: launcher.relativeX - 1000 ?? 0
                y: launcher.relativeY - 1000 ?? 0
                width: launcher.width + 2000 ?? 0
                height: launcher.height + 2000 ?? 0
                intersection: Intersection.Subtract
            }

            mask: Region {
                x: 8
                y: bar.height
                width: drawerWindow.width - 16
                height: drawerWindow.height - bar.height - 8
                intersection: Intersection.Subtract
                
                regions: [popup.visible ? barPopupR : null, 
                          osd.visible ? osdR : null,
                          launcher.visible ? launcherR : null]
            }
            

            PopupsController {
                id: popupsController
                barPopup: popup
                osd: osd
                launcher: launcher
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
                    id: popup
                    window: drawerWindow
                    screen: drawerScope.modelData
                    content: drawerWindow.popup
                    visible: false
                } 
            OsdWrapper {
                id: osd
                screen: drawerScope.modelData
                window: drawerWindow
            }
            LauncherWrapper {
                id: launcher
                screen: drawerScope.modelData
                window: drawerWindow
            }
        }
    } 
}