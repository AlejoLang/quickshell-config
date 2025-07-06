import QtQuick
import "root:/services/"
import "./popup"

Row {
    spacing: 5
    width: 30
    id: root
    Text {
        text: Audio.currentSink ? (Audio.currentSink.audio.volume.toFixed(2) * 100).toFixed(0) : "No Audio Sink"
        color: "white"
        font.pixelSize: 16
        MouseArea {
            anchors.fill: parent
            onClicked:{
                if (audioPopout.visible) {
                    audioPopout.visible = false;
                    focusGrab.active = false;
                    panelWindow.openedPopup = null; 
                } else {
                    audioPopout.visible = true;
                    panelWindow.openedPopup = audioPopout;
                    focusGrab.active = true; // Disable focus grab to allow interaction with the popup
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