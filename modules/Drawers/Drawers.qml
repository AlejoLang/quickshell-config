import Quickshell
import "../Bar"

Variants {
    model: Quickshell.screens
    PanelWindow {
        property var modelData
        screen: modelData
        anchors {
            top: true
            left: true
            right: true
        }
        color: "#252525"
        implicitHeight: 40

        Bar {
            id: bar
        }
    }
}