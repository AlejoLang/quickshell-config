import Quickshell
import QtQuick
import "root:/services/"

PopupWindow {
    id: root
    anchor.window: panelWindow
    anchor.rect.x: audioWidget.x + (audioWidget.width / 2) - (root.implicitWidth / 2)
    anchor.rect.y: panelWindow.implicitHeight + 10
    implicitWidth: 500
    implicitHeight: 160
    visible: false
    color: "transparent"
    Rectangle {
        anchors.fill: parent
        color: "#252525"
        radius: 10
        border.color: "#444444"
        border.width: 3
        Column {
            width: parent.width
            spacing: 0
            NodeEntry {
                id: currentSinkEntry
                node: Audio.currentSink
                anchors.horizontalCenter: parent.horizontalCenter
            } 
            NodeEntry {
                id: currentSourceEntry
                node: Audio.currentSource
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}