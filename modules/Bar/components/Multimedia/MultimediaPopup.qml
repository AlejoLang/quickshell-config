pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import "../../../general" 
import "root:/services/" as Services

Rectangle {
    id: root
    implicitHeight: 200
    implicitWidth: 600
    color: "#EFEFEF"
    bottomLeftRadius: 10
    bottomRightRadius: 10

    function convertSecondsToTime(seconds) {
        const date = new Date(seconds * 1000);
        return date.toISOString().substr(11, 8); // HH:MM:SS
    }


    Image {
        id: coverImg
        width: parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent
        source: (Services.Media.currentPlayer?.trackArtUrl.toString() || "")
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
                text: (Services.Media.currentPlayer.trackTitle) || "No track playing"
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
                text: Services.Media.trackArtist || "Unknown Artist"
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
                background_color: "#252525"
                onClicked: {
                    Services.Media.decreasePlayerIndex(); 
                }
            } 
            DefaultButton {
                text: Services.Media.currentPlayer.isPlaying ? "pause" : "play_arrow"
                background_color: "#252525"
                onClicked: {
                    if (Services.Media.currentPlayer) {
                        Services.Media.currentPlayer.togglePlaying();
                    }
                }
            }
            DefaultButton {
                text: "keyboard_arrow_right"
                background_color: "#252525"
                onClicked: {
                    Services.Media.increasePlayerIndex(); 
                }
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 10
            Layout.bottomMargin: 15
            Text {
                text: Services.Media.currentPlayer?.position ? 
                    Services.Media.getPlayerPosAsTime(seekSlider.position * (seekSlider.to - seekSlider.from) + seekSlider.from) + " / " + 
                    Services.Media.getPlayerLengthAsTime(Services.Media.currentPlayer.length) : "0 / 0"
                font.pixelSize: 16
                font.family: "CaskaydiaCove Nerd Font"
                Layout.alignment: Qt.AlignHCenter
            }
            DefaultSlide {
                id: seekSlider
                Layout.fillWidth: true
                Layout.margins: 10
                Layout.preferredHeight: 10
                from: 0
                to: Services.Media.currentPlayer?.length || 100
                value: Services.Media.currentPlayer?.position || 0
                stepSize: 1
                live: false
                onValueChanged: {
                    if (Services.Media.currentPlayer) {
                        Services.Media.setPlayerPosition(Services.Media.currentPlayer, value);
                    }
                }
            }
        }
    }
    FrameAnimation {
        running: Services.Media.currentPlayer?.playbackState == MprisPlaybackState.Playing
        onTriggered: Services.Media.currentPlayer?.positionChanged()
    }
}