pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

Button {
  id: root
  property bool statusPressed 
  property bool autoToggle: true
  property color backgroundActiveColor
  property color backgroundInactiveColor
  property color textActiveColor
  property color textInactiveColor
  property string buttonIcon

  enum Size {
    XS,
    S,
    M,
    L,
    XL
  }

  property int size
  property real buttonSize: size == MaterialToggleButton.Size.XS ? 26 : MaterialToggleButton.Size.S ? 34 : MaterialToggleButton.Size.M ? 50 : MaterialToggleButton.Size.L ? 90 : MaterialToggleButton.Size.XL ? 130 : 10
  property real iconSize: size == MaterialToggleButton.Size.XS ? 14 : MaterialToggleButton.Size.S ? 18 : MaterialToggleButton.Size.M ? 18 : MaterialToggleButton.Size.L ? 26 : MaterialToggleButton.Size.XL ? 34 : 5
  property real buttonRadiusActive: size == MaterialToggleButton.Size.XS ? 6 : MaterialToggleButton.Size.S ? 6 : MaterialToggleButton.Size.M ? 10 : MaterialToggleButton.Size.L ? 22 : MaterialToggleButton.Size.XL ? 22 : 2

  width: buttonSize
  height: buttonSize

  background: Rectangle {
    id: buttonBackground
    width: root.buttonSize
    height: root.buttonSize
    radius: root.pressed ? root.buttonRadiusActive : root.statusPressed ? root.buttonRadiusActive : (root.width / 2)
    color: root.statusPressed ? root.backgroundActiveColor : root.backgroundInactiveColor
    Behavior on radius {
      PropertyAnimation {
        target: buttonBackground
        property: "radius"
        duration: 100
        easing.type: Easing.InOutQuad
      }
    }
    Behavior on color {
      PropertyAnimation {
        target: buttonBackground
        property: "color"
        duration: 100
        easing.type: Easing.InOutQuad
      }
    }
  }

  contentItem: Text {
    id: buttonText
    text: root.buttonIcon
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: root.statusPressed ? root.textActiveColor : root.textInactiveColor
    Behavior on color {
      PropertyAnimation {
        target: buttonText
        property: "color"
        duration: 100
        easing.type: Easing.InOutQuad
      }
    }
  }

  onClicked: {
    if (root.autoToggle) {
      root.statusPressed = !root.statusPressed
    }
  }
}