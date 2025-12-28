pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.modules.Bar
import qs.services

Item {
  id: root
  property Popup mainPopup

  implicitWidth: audioRow.width
  implicitHeight: audioRow.height
  RowLayout {
    id: audioRow
    spacing: 5
    Text {
      // qmllint disable unqualified
      id: volumeIcon
      text: Audio.getNodeVolumeIcon(Audio?.currentSink?.id ?? -1)
      font.family: "Material Symbols Rounded"
      font.pixelSize: 24
      Layout.alignment: Qt.AlignVCenter
    }
    Text {
      id: volumePercentage
      text: Audio.getCurrentSinkVolumePerc()
      font.pixelSize: 16
      horizontalAlignment: Qt.AlignRight
      verticalAlignment: Qt.AlignVCenter
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