import QtQuick
import "root:/services/" as Services

Rectangle {
    id: root
    implicitHeight: parent.implicitHeight
    implicitWidth: audioRow.width
    color: "transparent"

    Row {
        id: audioRow
        spacing: 5
        width: audioIcon.width + audioVolume.width + 10 
        Text {
            id: audioIcon
            text: Services.Audio.getCurrentSinkIcon()
            font.family: "Material Symbols Rounded"
            font.pixelSize: 24
            color: "#252525"
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            id: audioVolume
            text: Services.Audio.getCurrentSinkVolumePerc()
            font.pixelSize: 16
            font.family: "CaskaydiaCove Nerd Font"
            color: "#252525"
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0.5
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
        onWheel: (event) => {
            if (event.angleDelta.y < 0) {
                Services.Audio.changeCurrentSinkVolume(-0.05);
            } else if (event.angleDelta.y > 0) {
                Services.Audio.changeCurrentSinkVolume(0.05);
            }
            event.accepted = true;
        }
    }
}