pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import qs.services
import qs.modules.Widgets

Item {
  id: root
  property list<PwNode> nodeList
  property PwNode selectedNode
  property bool expanded: false
  width: 410
  height: childrenRect.height
  
   Column {
    id: nodeCol
    width: parent.width
    height: childrenRect.height
    spacing: 5
    RowLayout {
      id: nodeId
      spacing: 5
      width: parent.width
      Text {
        id: nodeIcon
        text: Audio.getCurrentNodeIcon(root.selectedNode.id);
        font.family: "Material Symbols Rounded"
        font.pixelSize: 32
      }
      Text {
        id: nodeName
        text: root.selectedNode.description
        font.pixelSize: 24
        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        Layout.fillWidth: true
        clip: true
      }
      MaterialIconButton{
        id: openListButton
        buttonIcon: root.expanded ? "arrow_drop_up" : "arrow_drop_down"
        backgroundColor: "#32acac"
        textColor: "#404040"
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        onClicked: {
          root.expanded = !root.expanded
        }
      } 
    }
    MaterialSlider {
      id: audioSlider
      size: MaterialSlider.Size.XS
      colorActive: "#32acac"
      colorInactive: "#404040"
      height: 30
      width: parent.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      stepSize: 0.01
      snapMode: Slider.SnapAlways
      value: root.selectedNode?.audio?.volume ?? 0
      onPositionChanged: {
        console.log(audioSlider.position)
        Audio.setNodeVolume(root.selectedNode.id, audioSlider.position)
      }
      Timer {
        id: refreshTimer

      }
    }
    Column {
      id: nodeListColumn
      height: root.expanded ? childrenRect.height : 0 
      width: parent.width
      Repeater {
        model: root.nodeList
        Text {
          required property PwNode modelData
          text: modelData.description
          width: parent.width
          clip: true
          MouseArea {
            anchors.fill: parent
            onClicked: {
              Audio.switchDefaultNode(parent.modelData.id)
            }
          }
        }
      }
      Behavior on height {
        NumberAnimation {
          duration: 200
        }
      }
    }
  }
}