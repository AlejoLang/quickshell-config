import Quickshell
import QtQuick
import QtQuick.Effects
import "../Bar"

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: root
        property var modelData
        screen: modelData
        anchors {
            top: true
            left: true
            right: true
        }
        
        color: "#252525"
        implicitHeight: 40

       Bar {} 
    }
}