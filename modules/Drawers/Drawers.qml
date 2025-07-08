pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
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
                regions: []
            }

            Bar {
                id: bar
                screen: drawerScope.modelData
            }
        }

    } 
}