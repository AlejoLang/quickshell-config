pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell.Services.Mpris
import qs.services
import qs.modules.Widgets

Item {
  id: root
  width: 600
  height: 200

  Rectangle {
    clip: true
    anchors.fill: parent
    radius: 10
    Image {
      id: trackImage
      source: Media.currentPlayer.trackArtUrl
      anchors.fill: parent
      width: parent.width
      height: parent.height
      fillMode: Image.PreserveAspectCrop
      opacity: 0.6
      layer.enabled: true
      visible: false
    }
    MultiEffect {
        source: trackImage
        anchors.fill: trackImage
        maskEnabled: true
        maskSource: mask
        opacity: 0.6
    }
    Item {
        id: mask
        width: trackImage.width
        height: trackImage.height
        layer.enabled: true
        visible: true
        Rectangle {
            width: trackImage.width
            height: trackImage.height
            radius: 10
            color: "white"
            opacity: 0.2
        }
    }
  }

  Column {
    anchors.fill: parent
    Text {
      id: trackTitle
      width: parent.width - 20
      text: Media.currentPlayer.trackTitle || "Unknown Title"
      horizontalAlignment: text.length * (font.pixelSize / 2) > width ? Qt.AlignLeft : Qt.AlignHCenter
      anchors.horizontalCenter: parent.horizontalCenter
      topPadding: 20
      font.pixelSize: 30
      font.weight: 700
      clip: true
    }
    Text {
      id: trackArtist
      width: parent.width - 20
      text: Media.currentPlayer.trackArtist || "Unknown Artist"
      horizontalAlignment: text.length * (font.pixelSize / 2) > width ? Qt.AlignLeft : Qt.AlignHCenter
      anchors.horizontalCenter: parent.horizontalCenter
      topPadding: 5
      font.pixelSize: 18
      clip: true
    }
    Row {
      id: trackControls
      topPadding: 30
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 10
      MaterialIconButton {
        id: previousPlayerButton
        buttonIcon: "keyboard_arrow_left"
        onClicked: {
          Media.decreasePlayerIndex()
        }
      }
      MaterialIconButton {
        id: previousTrackButton
        visible: Media.currentPlayer.canGoPrevious
        buttonIcon: "skip_previous"
        onClicked: {
          Media.currentPlayer.previous()
        }
      }
      MaterialIconButton {
        id: playPauseButton
        visible: Media.currentPlayer.canPause && Media.currentPlayer.canPlay
        buttonIcon: Media.currentPlayer.playbackState == MprisPlaybackState.Playing ? "pause" : "play_arrow"
        onClicked: {
          Media.currentPlayer.togglePlaying()
        }
      }
      MaterialIconButton {
        id: nextTrackButton
        visible: Media.currentPlayer.canGoNext
        buttonIcon: "skip_next"
        onClicked: {
          Media.currentPlayer.next()
        }
      }
      MaterialIconButton {
        id: nextPlayerButton
        buttonIcon: "keyboard_arrow_right"
        onClicked: {
          Media.increasePlayerIndex()
        }
      }
    }
    MaterialIndicator {
      id: trackProgressionIndicator
      width: parent.width - 20
      height: 40
      anchors.horizontalCenter: parent.horizontalCenter
      animating: Media.currentPlayer.playbackState == MprisPlaybackState.Playing
      value: Media.currentPlayer.position / Media.currentPlayer.length
      live: false
      Timer {
        running: Media.currentPlayer.playbackState == MprisPlaybackState.Playing && root.visible && !trackProgressionIndicator.pressed
        repeat: true
        interval: 100
        onTriggered: {
          Media.currentPlayer.positionChanged()
        }
      } 
      onPressedChanged: {
        let seekL = Media.currentPlayer.length * trackProgressionIndicator.value
        if(!trackProgressionIndicator.pressed) {
          Media.currentPlayer.position = seekL
        }
      }

      onValueChanged: {
        let seekL = Media.currentPlayer.length * trackProgressionIndicator.value
        if(Math.abs(seekL - Media.currentPlayer.position) > 1000) {
          Media.setPlayerPosition(Media.currentPlayer, seekL);
          Media.currentPlayer.position = seekL
        }
      }
    }
  }
  
}