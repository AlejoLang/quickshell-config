import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "root:/services" as Services
import QtQuick.Controls
import "../general/"

RowLayout {
    id: root
    property PwNode currentSink: Services.Audio.currentSink
    property PwNode currentSource: Services.Audio.currentSource
    width: parent.width
    height: parent.height
    spacing: 10

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.topMargin: 10
        Layout.bottomMargin: 10
        Layout.leftMargin: 10
        Text {
            text: Services.Audio.getCurrentSourceIcon()
            Layout.alignment: Qt.AlignHCenter
            font.family: "Material Symbols Rounded"
            font.pixelSize: 36
            font.bold: true
        }
        DefaultSlide{
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Vertical
            from: 0
            to: 1
            stepSize: 0.01
            value: root.currentSource?.audio.volume || 0
            onValueChanged: {
                if (root.currentSource) {
                    Services.Audio.setNodeVolume(root.currentSource.id, value);
                }
            }
            Text {
                text: (Services.Audio.currentSource.audio.volume.toFixed(2) * 100).toFixed(0)
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                font.bold: true
            }
        } 
    }
    ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.topMargin: 10
        Layout.bottomMargin: 10
        Layout.rightMargin: 10
        Text {
            text: Services.Audio.getCurrentSinkIcon()
            Layout.alignment: Qt.AlignHCenter
            font.family: "Material Symbols Rounded"
            font.pixelSize: 36
            font.bold: true
        }
        DefaultSlide{
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Vertical
            from: 0
            to: 1
            stepSize: 0.01
            value: root.currentSink?.audio.volume || 0
            onValueChanged: {
                if (root.currentSink) {
                    console.log("Setting volume to:", value);
                    Services.Audio.setNodeVolume(root.currentSink.id, value);
                }
            }
            Text {
                text: (Services.Audio.currentSink.audio.volume.toFixed(2) * 100).toFixed(0)
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                font.bold: true
            }
        } 
    }
}
