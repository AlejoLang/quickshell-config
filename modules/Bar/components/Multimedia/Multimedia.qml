pragma ComponentBehavior: Bound

import Quickshell.Services.Mpris
import Quickshell
import QtQuick
import "../"

Rectangle {
    id: root
    
    required property ShellScreen screen
    required property Item bar
    property list<MprisPlayer> players: Mpris.players.values ?? null
    property int currentPlayerIdx: 0
    property MprisPlayer currentPlayer: players[currentPlayerIdx] ?? null


    onPlayersChanged: {
        if(currentPlayerIdx > (players.length - 1)) {
            currentPlayerIdx = players.length - 1;
        }
        currentPlayer = players[currentPlayerIdx] ?? null;
    }

    implicitHeight: parent.height
    implicitWidth: mediaRow.width
    color: "transparent"

    Row {
        id: mediaRow
        spacing: 5
        width: mediaIcon.width + mediaText.width + 5
        height: parent.implicitHeight

        Text {
            id: mediaIcon
            text: 'graphic_eq'
            font.family: "Material Symbols Rounded"
            font.pixelSize: 24
            color: "#252525"
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            id: mediaText
            text: {
                if (root.currentPlayer) {
                    return root.currentPlayer.trackTitle.length > 40 ? 
                        root.currentPlayer.trackTitle.substring(0, 40) + "..." :
                        root.currentPlayer.trackTitle;
                }
                return "No track playing";
            }
            font.pixelSize: 16
            font.family: "CaskaydiaCove Nerd Font"
            color: "#252525"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            root.color = "#d6d6d6"
        }
        onExited: {
            root.color = "transparent"
        }
        onClicked: {
            if (popup.visible) {
                if (popup.content === root.popComponent) {
                    popup.visible = false;
                } else {
                    popup.changeContent(root.popComponent);
                }
            } else {
                popup.changeContent(root.popComponent);
                popup.visible = true;
            }
        }
        onWheel: (event) => {
            if (event.angleDelta.y < 0) {
                root.currentPlayerIdx = (root.currentPlayerIdx - 1 + root.players.length) % root.players.length;
            } else if (event.angleDelta.y > 0) {
                root.currentPlayerIdx = (root.currentPlayerIdx + 1) % root.players.length;
            }
            event.accepted = true;
        }
    }

    property PopupContent popComponent: PopupContent {
        width: multimediaPopup.width
        height: multimediaPopup.height
        owner: root
        id: popRect
        MultimediaPopup {
            id: multimediaPopup
            currentPlayer: root.currentPlayer
            players: root.players
            currentPlayerIdx: root.currentPlayerIdx
        } 
    }
}
