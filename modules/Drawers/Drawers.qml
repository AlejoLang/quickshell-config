pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Effects
import "../Bar"

Variants {
    model: Quickshell.screens
    id: root
    Scope {
        id: drawerScope
        required property ShellScreen modelData

        PanelWindow {
            id: drawerWindow
            screen: drawerScope.modelData
            exclusionMode: ExclusionMode.Ignore
            color: "transparent"
            
            anchors {
                top: true
                right: true
                left: true
                bottom: true
            }

            mask: Region {
                x: 0
                y: bar.height
                width: !popup.visible ? drawerWindow.width : 0
                height: drawerWindow.height - bar.height
                intersection: Intersection.Subtract
                regions: [popupBackground]
            }

            Exclusions {
                screen: drawerScope.modelData
                bar: bar
            }
            Item {
                id: borderItems
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#010101"
                    blurMax: 30
                }
                Borders {
                    screen: drawerScope.modelData
                    bar: bar
                }
                Rectangle {
                    id: popupShadow
                    width: popup.implicitWidth
                    height: popup.implicitHeight - 10
                    x: popup.targetX
                    y: popup.anchor.rect.y + popup.targetY
                    visible: popup.visible
                    radius: 10
                    color: "#efefef"
                    onHeightChanged: {
                        console.log(popupShadow.height)
                    }
                    Behavior on width {
                        enabled: popup.visible && !popup.opening_closing && !popup.isReplacing
                        NumberAnimation {
                            duration: 10
                        }
                    }
                    Behavior on height {
                        enabled: popup.visible && !popup.opening_closing && !popup.isReplacing
                        NumberAnimation {
                            duration: 10
                        }
                    }
                }   
            }
            Bar {
                id: bar
                mainPopup: popup
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
            } 
            PopupQuitter {
                id: popupBackground
                popup: popup
                bar: bar
                window: drawerWindow
                screen: drawerScope.modelData
            }
            Popup{
                id: popup
                bar: bar
                window: drawerWindow
            }
           
        }
    }
}