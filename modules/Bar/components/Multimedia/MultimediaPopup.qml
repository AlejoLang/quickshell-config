pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell.Services.Mpris
import "../../../general" 

Rectangle {
    id: root
    property list<MprisPlayer> players
    property int currentPlayerIdx
    property MprisPlayer currentPlayer
    implicitHeight: 200
    implicitWidth: 600
    radius: 20
    border.width: 2
    border.color: "#000000"

    onPlayersChanged: {
        if(currentPlayerIdx > (players.length - 1)) {
            currentPlayerIdx = Math.max(0, players.length - 1);
        }
        currentPlayer = players[currentPlayerIdx];
    }

    Image {
        id: coverImg
        anchors.fill: parent
        source: (root.currentPlayer?.trackArtUrl.toString() || "")
        fillMode: Image.PreserveAspectCrop
        opacity: 0.4
        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: coverMask
            maskEnabled: true
            maskInverted: false
            brightness: -0.2
        }
    }
    Item {
        id: coverMask
        width: coverImg.width
        height: coverImg.height
        visible: false
        layer.enabled: true
        Rectangle {
            anchors.fill: parent
            radius: 20
            antialiasing: false
            color: "white"
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20
        width: parent.width
        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            Text {
                text: (root.currentPlayer.trackTitle) || "No track playing"
                clip: true
                width: parent.width
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 24
                font.family: "CaskaydiaCove Nerd Font"
                font.bold: true
                color: "#252525"
                anchors.horizontalCenter: parent.horizontalCenter
            } 
            Text {
                text: root.currentPlayer.trackArtist || "Unknown Artist"
                font.pixelSize: 18
                font.family: "CaskaydiaCove Nerd Font"
                color: "#252525"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            DefaultButton {
                text: "keyboard_arrow_left"
                onClicked: {
                    const newIdx = (root.currentPlayerIdx - 1 + root.players.length) % root.players.length;
                    root.currentPlayerIdx = newIdx;
                    root.currentPlayer = root.players[newIdx];
                }
            } 
            DefaultButton {
                text: root.currentPlayer.isPlaying ? "pause" : "play_arrow"
                onClicked: {
                    if (root.currentPlayer) {
                        root.currentPlayer.togglePlaying();
                    }
                }
            }
            DefaultButton {
                text: "keyboard_arrow_right"
                onClicked: {
                    const newIdx = (root.currentPlayerIdx + 1) % root.players.length;
                    root.currentPlayerIdx = newIdx;
                    root.currentPlayer = root.players[newIdx];
                }
            }
        }
        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 20
            width: parent.width
            Item {
                property var posAux: null;
                width: parent.width - 20
                height: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#d6d6d6"
                }
                Rectangle {
                    width: parent.posAux ?? (root.currentPlayer ? root.currentPlayer.position / root.currentPlayer.length * parent.width : 0)
                    height: parent.height
                    radius: 5
                    color: "#252525"  
                }
                MouseArea {
                    anchors.fill: parent
                    onReleased: (event) => {
                        if (event.button == Qt.LeftButton) {
                            const secsPix = parent.posAux ?? event.x;
                            const secs = (secsPix * root.currentPlayer.length) / parent.width;
                            if (root.currentPlayer) {
                                root.currentPlayer.seek(secs - root.currentPlayer.position);
                            }
                            parent.posAux = null; // Reset the auxiliary position
                        }
                    }
                    onPositionChanged: (event) => {
                        if (event.buttons == Qt.LeftButton) {
                            if (root.currentPlayer) {
                                parent.posAux = Math.min(event.x, parent.width);
                            }
                        }
                    }
                }
            }
        }
    }
    FrameAnimation {
        running: root.currentPlayer.playbackState == MprisPlaybackState.Playing
        onTriggered: root.currentPlayer.positionChanged()
    }
}