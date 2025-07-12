pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../../../general" 

Rectangle {
    id: root
    property list<MprisPlayer> players
    property int currentPlayerIdx
    property MprisPlayer currentPlayer
    implicitHeight: 200
    implicitWidth: 600
    color: "#EFEFEF"
    bottomLeftRadius: 10
    bottomRightRadius: 10

    onPlayersChanged: {
        if(currentPlayerIdx > (players.length - 1)) {
            currentPlayerIdx = Math.max(0, players.length - 1);
        }
        currentPlayer = players[currentPlayerIdx];
    }

    Image {
        id: coverImg
        width: parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent
        source: (root.currentPlayer?.trackArtUrl.toString() || "")
        fillMode: Image.PreserveAspectCrop
        opacity: 0.4
        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: coverMask
            maskEnabled: true
            maskInverted: false
            brightness: -0.3
        }
    }
    Item {
        id: coverMask
        width: coverImg.width - 20
        height: coverImg.height - 20
        anchors.centerIn: parent
        visible: false
        layer.enabled: true
        Rectangle {
            radius: 8
            anchors.fill: parent
            antialiasing: false
            color: "white"
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20
        width: parent.width
        ColumnLayout {
            spacing: 5
            Layout.fillWidth: true
            Text {
                text: (root.currentPlayer.trackTitle) || "No track playing"
                Layout.fillWidth: true
                Layout.maximumHeight: font.pixelSize + 10
                clip: true
                elide: Text.ElideRight
                padding: 5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 24
                font.family: "CaskaydiaCove Nerd Font"
                font.bold: true
                color: "#252525"
            } 
            Text {
                Layout.fillWidth: true
                Layout.maximumHeight: font.pixelSize + 10
                text: root.currentPlayer.trackArtist || "Unknown Artist"
                font.pixelSize: 18
                font.family: "CaskaydiaCove Nerd Font"
                color: "#252525"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        Row {
            spacing: 10
            Layout.alignment: Qt.AlignHCenter
            DefaultButton {
                text: "keyboard_arrow_left"
                backgroundColor: "#252525"
                onClicked: {
                    const newIdx = (root.currentPlayerIdx - 1 + root.players.length) % root.players.length;
                    root.currentPlayerIdx = newIdx;
                    root.currentPlayer = root.players[newIdx];
                }
            } 
            DefaultButton {
                text: root.currentPlayer.isPlaying ? "pause" : "play_arrow"
                backgroundColor: "#252525"
                onClicked: {
                    if (root.currentPlayer) {
                        root.currentPlayer.togglePlaying();
                    }
                }
            }
            DefaultButton {
                text: "keyboard_arrow_right"
                backgroundColor: "#252525"
                onClicked: {
                    const newIdx = (root.currentPlayerIdx + 1) % root.players.length;
                    root.currentPlayerIdx = newIdx;
                    root.currentPlayer = root.players[newIdx];
                }
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.maximumHeight: 10
            Layout.preferredHeight: 10
            Layout.bottomMargin: 15
            Item {
                property var posAux: null;
                width: parent.width - 20
                height: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#7c7c7c"
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