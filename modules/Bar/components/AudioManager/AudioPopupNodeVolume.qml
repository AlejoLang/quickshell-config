import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "root:/services/" as Services
import "../../../general/"

Item {
    id: root
    property PwNode node
    width: parent.width
    height: childrenRect.height
    ColumnLayout {
        spacing: 5
        width: parent.width
        RowLayout {
            spacing: 5
            Layout.fillWidth: true
            Text {
                text: root.node.isSink ? "volume_up" : "mic"
                font.family: "Material Symbols Rounded"
                font.pixelSize: 24
                Layout.preferredWidth: 24
            }
            Text {
                text: root.node.description
                font.pixelSize: 18
                font.family: "CaskaydiaCove Nerd Font"
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            Text {
                text: (root.node.audio.volume.toFixed(2) * 100).toFixed(0) + "%"
                font.pixelSize: 18
                Layout.preferredWidth: 50
                Layout.leftMargin: 10
                font.family: "CaskaydiaCove Nerd Font"
            }
        } 
        DefaultSlide {
            id: volumeSlider
            orientation: Qt.Horizontal
            Layout.fillWidth: true
            Layout.preferredHeight: 10
            from: 0
            to: 1
            stepSize: 0.01
            value: root.node?.audio?.volume || 0
            onValueChanged: {
                Services.Audio.setNodeVolume(root.node.id, value);
            }
        }
    }
}