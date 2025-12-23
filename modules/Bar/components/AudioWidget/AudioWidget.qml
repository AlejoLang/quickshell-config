pragma ComponentBehavior: Bound
import QtQuick
import qs.modules.Bar
import qs.services

Item {
  id: root
  property Popup mainPopup

  implicitWidth: audioRow.width
  implicitHeight: audioRow.height
  Row {
    id: audioRow
    spacing: 5
    Text {
      // qmllint disable unqualified
      text: Audio.getCurrentSinkIcon()
      font.family: "Material Symbols Rounded"
      font.pixelSize: 24
      anchors.verticalCenter: parent.verticalCenter
    }
    Text {
      text: Audio.getCurrentSinkVolumePerc()
      anchors.verticalCenter: parent.verticalCenter
    }
  }
  MouseArea {
    anchors.fill: parent
    onWheel: (event) => {
      if(event.angleDelta.y > 0) {
        Audio.increaseCurrentSinkVolume(0.01);
      } else {
        Audio.increaseCurrentSinkVolume(-0.01);
      }
    }
    onClicked: {
      if (root.mainPopup.content == audioPopup) {
        root.mainPopup.close();
        return;
      }
        root.mainPopup.setContent(audioPopup, root)
    }
  }
  AudioPopup {
    id: audioPopup
    visible: false
  }
}