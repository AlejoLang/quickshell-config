pragma ComponentBehavior: Bound

import Quickshell.Services.Mpris
import Quickshell
import QtQuick
import "../"
import "root:/services/" as Services

Rectangle {
    id: root
    
    required property ShellScreen screen
    required property Item bar

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
                if (Services.Media.currentPlayer) {
                    return Services.Media.currentPlayer.trackTitle.length > 40 ?
                        Services.Media.currentPlayer.trackTitle.substring(0, 40) + "..." :
                        Services.Media.currentPlayer.trackTitle;
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
            popup.changeContent(root.popComponent);
            popup.open();
        }
        onWheel: (event) => {
            if (event.angleDelta.y < 0) {
                Services.Media.decreasePlayerIndex();
            } else if (event.angleDelta.y > 0) {
                Services.Media.increasePlayerIndex();
            }
            event.accepted = true;
        }
    }

    property PopupContent popComponent: PopupContent {
        width: multimediaPopup.width
        window: root.bar
        height: multimediaPopup.height
        owner: root
        id: popRect
        MultimediaPopup {
            id: multimediaPopup
        } 
    }
}
