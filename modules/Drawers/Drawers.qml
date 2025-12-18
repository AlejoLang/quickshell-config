pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Effects

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
                width: drawerWindow.width
                height: drawerWindow.height - bar.height
                intersection: Intersection.Subtract
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
            }

            Rectangle {
                id:bar
                implicitHeight: 40
                implicitWidth: parent.implicitWidth
                color: "#efefef"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
            }

        }
    } 
}