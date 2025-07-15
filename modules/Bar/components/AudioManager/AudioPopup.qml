import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "root:/services/" as Services
import "../../../general/"

Rectangle {
    id: root
    property list<PwNode> sinksList: Services.Audio.sinksList
    property list<PwNode> sourcesList: Services.Audio.sourcesList
    implicitWidth: 400
    implicitHeight: nodesColumn.height
    color: "#EFEFEF"
    bottomLeftRadius: 10
    bottomRightRadius: 10

    Column {
        id: nodesColumn
        spacing: 10
        padding: 10
        width: parent.implicitWidth

        Column {
            spacing: 10
            width: parent.width - 20
            AudioPopupNodeVolume {
                node: Services.Audio.currentSink
            }
            AudioPopupNodeVolume {
                node: Services.Audio.currentSource
            }
        }

        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            Text {
                text: "Sinks"
                font.pixelSize: 18
                font.family: "CaskaydiaCove Nerd Font"
                font.bold: true
            }
            Repeater {
               model: Services.Audio.sinksList
                AudioPopupNodeEntry {
                    node: modelData
                } 
            }
        }
        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            Text {
                text: "Sources"
                font.pixelSize: 18
                font.family: "CaskaydiaCove Nerd Font"
                font.bold: true
            }
            Repeater {
                model: root.sourcesList
                AudioPopupNodeEntry {
                    node: modelData
                } 
            }
        }
    }
}