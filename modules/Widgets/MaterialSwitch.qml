pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

Switch {
  id: root

  property color backgroundActiveColor
  property color backgroundInactiveColor
  property color indicatorActiveColor
  property color indicatorInactiveColor
  width: 50
  height: 30

  indicator: Rectangle {
    width: 50
    height: 30
    radius: 16
    color: root.checked ? root.backgroundActiveColor : root.backgroundInactiveColor
    border.width: 2
    border.color: root.checked ? root.indicatorActiveColor : root.indicatorInactiveColor
 
    Rectangle {
      id: indicator
      x: root.checked ? parent.width - width - 4 : 8
      anchors.verticalCenter: parent.verticalCenter
      width: root.checked ? 22 : 16
      height: root.checked ? 22 : 16
      radius: root.checked ? 12 : 8
      color: root.checked ? root.indicatorActiveColor : root.indicatorInactiveColor

      transitions: Transition {
        ParallelAnimation {
          PropertyAnimation {
            target: indicator
            properties: "x,width,height"
            duration: 100
            easing.type: Easing.InOutQuad
          }
        }
      }

      states: [
        State {
          name: "checked"
          when: root.checked
          PropertyChanges {
            target: indicator
            x: indicator.parent.width - indicator.width - 4
            width: 22
            height: 22
            radius: 12
          }
        },
        State {
          name: "unchecked"
          when: !root.checked
          PropertyChanges {
            target: indicator
            x: 8
            width: 16
            height: 16
            radius: 8
          }
        }
      ]
    }
  }


}