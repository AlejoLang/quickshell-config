pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Item {
  id: root
  width: trayItemsRow.width + 10

  property PanelWindow window

  Rectangle {
    anchors.fill: parent
    color: "#252525"
    opacity: 0.2
    radius: 10
  }
  RowLayout { 
    id: trayItemsRow
    height: parent.height - 10
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 5
    Repeater {
      model: SystemTray.items.values
      Rectangle {
        required property SystemTrayItem modelData
        Layout.preferredHeight: 20
        Layout.preferredWidth: 20
        Layout.alignment: Qt.AlignVCenter
        color: "transparent"
        IconImage {
          source: parent.modelData.icon
          implicitSize: parent.height 
        }
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.MiddleButton | Qt.LeftButton | Qt.RightButton
          onClicked: (event) => {
            console.log(event.button)
            if(event.button == Qt.LeftButton) {
              parent.modelData.activate()
            } else if(event.button == Qt.RightButton) {
              const pos = root.window.itemPosition(parent)
              console.log(pos.x, pos.y)
              parent.modelData.display(root.window, pos.x, pos.y + 30)
            } else if (event.button == Qt.MiddleButton) {
              parent.modelData.secondaryActivate()
            }
          }
          onWheel: (event) => {
            parent.modelData.scroll(event.angleDelta.y, false)
          }
        }
      }
    }
  }
}