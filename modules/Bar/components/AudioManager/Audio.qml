import QtQuick
import "root:/services/"
import "./"

Row {
    spacing: 5
    width: 30
    id: root
    Text {
        text: Audio.currentSink ? Audio.currentSink.audio.volume.toFixed(2) * 100 : "No Audio Sink"
        MouseArea {
            anchors.fill: parent
            onClicked:{
                if (audioPopout.visible) {
                    audioPopout.visible = false;
                } else {
                    audioPopout.visible = true;
                    panelWindow.openedPopup = audioPopout;
                }
            }
            onWheel: function(event) {
                if (event.angleDelta.y < 0) {
                    Audio.setNodeVolume(Audio.currentSink.id, Audio.currentSink.audio.volume - 0.05);
                } else {
                    Audio.setNodeVolume(Audio.currentSink.id, Audio.currentSink.audio.volume + 0.05);
                }
            }
        }
    }
    AudioPopup {
        id: audioPopout
        visible: false
    }
}