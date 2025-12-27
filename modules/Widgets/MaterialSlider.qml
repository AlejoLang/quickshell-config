pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

Slider {
  id: root

  enum Size {
    XS,
    S,
    M,
    L
  }

  property int size
  property string icon: ""
  property color colorActive
  property color colorInactive
  property real trackSize: size == MaterialSlider.Size.XS ? 16 : size == MaterialSlider.Size.S ? 24 : size == MaterialSlider.Size.M ? 40 : size == MaterialSlider.Size.L ? 56 : 96
  property real trackRadius: size == MaterialSlider.Size.XS ? 8 : size == MaterialSlider.Size.S ? 8 : size == MaterialSlider.Size.M ? 12 : size == MaterialSlider.Size.L ? 16 : 24
  property real handleHeight: size == MaterialSlider.Size.XS ? 44 : size == MaterialSlider.Size.S ? 44 : size == MaterialSlider.Size.M ? 52 : size == MaterialSlider.Size.L ? 68 : 108
  property real iconSize: size == MaterialSlider.Size.XS ? 0 : size == MaterialSlider.Size.S ? 16 : size == MaterialSlider.Size.M ? 24 : size == MaterialSlider.Size.L ? 24 : 32

  background: Rectangle {
    anchors.fill: parent
    color: "transparent"
    Rectangle {
      id: activeTrack
      x: root.orientation == Qt.Horizontal ? 0 : root.leftPadding + (root.availableWidth / 2) - (width / 2)
      y: root.orientation == Qt.Vertical ? 0 : root.topPadding + (root.availableHeight / 2) - (height / 2)
      width: root.orientation == Qt.Horizontal ? (root.visualPosition * parent.width) - 6  : root.trackSize
      height: root.orientation == Qt.Vertical ? (root.visualPosition * parent.height) - 6 : root.trackSize
      color:  root.colorActive
      topLeftRadius: root.orientation == Qt.Horizontal ? root.trackRadius : 2
      topRightRadius: 2
      bottomLeftRadius: root.trackRadius
      bottomRightRadius: root.orientation == Qt.Horizontal ? 2 : root.trackRadius
    }
    Rectangle {
      id: inactiveTrack
      x: root.orientation == Qt.Horizontal ? root.leftPadding + (root.visualPosition * root.availableWidth) + 6: 0
      y: root.orientation == Qt.Horizontal ? root.topPadding + (root.availableHeight / 2) - height / 2: root.topPadding + root.availableHeight
      width: root.orientation == Qt.Horizontal ? root.width - (root.visualPosition * root.availableWidth) - 6  : root.trackRadius
      height: root.orientation == Qt.Horizontal ? root.trackSize : -(root.visualPosition * parent.height) + 6
      color: root.colorInactive
      topLeftRadius: root.orientation == Qt.Horizontal ? 2 : root.trackRadius
      topRightRadius: root.trackRadius
      bottomLeftRadius: 2
      bottomRightRadius: root.orientation == Qt.Horizontal ? root.trackRadius : 2
    }
  }
  handle: Rectangle {
    id: handle
    x: root.orientation == Qt.Horizontal ? root.leftPadding + (root.visualPosition * root.availableWidth) - (width / 2) : root.leftPadding + (root.availableWidth / 2) - (width / 2)
    y: root.orientation == Qt.Vertical ? 0 : root.topPadding + (root.availableHeight / 2) - (height / 2)
    implicitHeight: root.orientation == Qt.Horizontal ? parent.height : 4
    implicitWidth: root.orientation == Qt.Vertical ? parent.width : 4
    radius: 2
    color: root.colorActive
    Behavior on width {
      PropertyAnimation {
        target: handle
        property: "width"
        duration: 50
      }
    }
    Behavior on height {
      PropertyAnimation {
        target: handle
        property: "height"
        duration: 50
      }
    }
  }

  Text {
    id: sliderIcon
    text: root.icon
    font.family: "Material Symbols Rounded"
    font.pixelSize: root.iconSize
    visible: root.icon != ""
    x: activeTrack.width > sliderIcon.width + 5 ? activeTrack.x + 5 : inactiveTrack.x + 5
    anchors.verticalCenter: parent.verticalCenter
    color: activeTrack.width > sliderIcon.width + 5 ? "#101010" : "#efefef"
  }

  onPressedChanged: {
    if(root.pressed) {
      if (root.orientation == Qt.Horizontal) {
        handle.width = 2;
      } else { 
        handle.height = 2;
      }
    } else {
      if (root.orientation == Qt.Horizontal) {
        handle.width = 4;
      } else { 
        handle.height = 4;
      }
    }
  }
}