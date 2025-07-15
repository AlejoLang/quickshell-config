import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "root:/services/" as Services

Item {
    id: root
    width: parent.width
    height: childrenRect.height
    property PwNode node
    readonly property var color:  {
        node.isSink ? node.id == Services.Audio.currentSink.id ? "#016b9c" : "#252525" :
        node.id == Services.Audio.currentSource.id ? "#016b9c" : "#252525"
    }
    RowLayout {
        spacing: 5
        width: parent.width
        Text {
            text: root.node.isSink ? "volume_up" : "mic"
            font.family: "Material Symbols Rounded"
            font.pixelSize: 24
            color: root.color
            Layout.preferredWidth: 24
        }
        Text {
            text: root.node.description
            font.pixelSize: 18
            color: root.color
            font.family: "CaskaydiaCove Nerd Font"
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: (event) => {
            if (event.button === Qt.LeftButton) {
                if (root.node.isSink) {
                    Services.Audio.switchAudioSink(root.node.id);
                } else {
                    Services.Audio.switchAudioSource(root.node.id);
                }
            }
            event.accepted = true;
        }
    }
}