pragma ComponentBehavior: Bound
import QtQuick
import qs.services

Item {
  id: root
  implicitWidth: multimediaRow.width
  implicitHeight: multimediaRow.height
  Row {
    id: multimediaRow
    spacing: 5
    Text {
      text: "music_note"
      font.family: "Material Symbols Rounded"
      font.pixelSize: 24
      anchors.verticalCenter: parent.verticalCenter
    }
    Text {
      property int maxChars: 40
      property string fullTitle: Media?.currentPlayer?.trackTitle ?? "No media"
      text: fullTitle.length > maxChars ? fullTitle.substring(0, maxChars) + "..." : fullTitle
      
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}