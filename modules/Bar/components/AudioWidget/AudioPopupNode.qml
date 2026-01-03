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
    anchors.centerIn: parent
    spacing: 5
    RowLayout {
      id: nodeId
      spacing: 5
      width: parent.width
      Text {
        id: nodeIcon
        text: Audio.getCurrentNodeIcon(root.selectedNode.id);
        font.family: "Material Symbols Rounded"
        font.pixelSize: 20
      }
      Text {
        id: nodeName
        text: root.selectedNode.description
        font.pixelSize: 20
        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        Layout.fillWidth: true
        clip: true
      }
      Row {
        MaterialIconButton{
        id: openListButton
        buttonIcon: root.expanded ? "arrow_drop_up" : "arrow_drop_down"
        onClicked: {
          root.expanded = !root.expanded
        }
      } 
      }
    }
    RowLayout {
      width: parent.width
      height: 60
      MaterialSlider {
        id: audioSlider
        size: MaterialSlider.Size.M
        icon: Audio.getNodeVolumeIcon(root?.selectedNode?.id ?? 0)
        Layout.fillHeight: true
        Layout.fillWidth: true
        stepSize: 0.01
        snapMode: Slider.SnapAlways
        value: root.selectedNode?.audio?.volume ?? 0
        onPositionChanged: {
          Audio.setNodeVolume(root.selectedNode.id, audioSlider.position)
        }
      }
    }
    Column {
      id: nodeListColumn
      height: root.expanded ? childrenRect.height : 0 
      width: parent.width
      spacing: 4
      Repeater {
        model: root.nodeList
        Text {
          required property PwNode modelData
          text: modelData.description
          font.pixelSize: 16
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