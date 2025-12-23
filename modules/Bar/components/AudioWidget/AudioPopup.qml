pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.Pipewire
import qs.services

Item {
  id: root
  implicitHeight: audioPopupRect.height
  implicitWidth: audioPopupRect.width
  Rectangle{
    id: audioPopupRect
    implicitHeight: audioPopupCol.height
    implicitWidth: audioPopupCol.width
    color: "transparent"
    Column {
      spacing: 30
      id: audioPopupCol 
      AudioPopupNode {
        nodeList: Audio.sinksList
        selectedNode: Audio.currentSink
      }
      AudioPopupNode {
        nodeList: Audio.sourcesList
        selectedNode: Audio.currentSource
      }
    }
  }
}