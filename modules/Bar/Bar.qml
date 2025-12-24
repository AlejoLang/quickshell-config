pragma ComponentBehavior: Bound
import QtQuick
import "components/Workspaces"
import "components/CurrentWindow"
import "components/DateTime"
import "components/BatteryWidget"
import "components/AudioWidget"
import "components/MultimediaWidget"
import "components/NetworkWidget"
import "components/BluetoothWidget"

Item {
  id: root
  property Popup mainPopup

  implicitHeight: 45
  Rectangle {
    anchors.fill: parent
    anchors.topMargin: 8
    anchors.bottomMargin: 8
    anchors.leftMargin: 16
    anchors.rightMargin: 16
    color: "transparent"
    Row {
      id: barLayout
      spacing: 20
      anchors.fill: parent
      anchors.verticalCenter: parent.verticalCenter
      Row {
        id: leftBarModule
        anchors.left: barLayout.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20
        Workspaces {
          id: workspaces 
          anchors.verticalCenter: parent.verticalCenter
          mainPopup: root.mainPopup
        }
        CurrentWindow {
          id: currentWindow
          anchors.verticalCenter: parent.verticalCenter
        }
      }
      Row {
        id: centerBarModule
        spacing: 20
        anchors.centerIn: parent
        MultimediaWidget {
          anchors.verticalCenter: parent.verticalCenter
        }
      }
      Row {
        id: rightBarModule
        anchors.right: barLayout.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20
        NetworkWidget{
          anchors.verticalCenter:parent.verticalCenter
        }
        BluetoothWidget {
          anchors.verticalCenter: parent.verticalCenter
        }
        AudioWidget {
          mainPopup: root.mainPopup
          anchors.verticalCenter: parent.verticalCenter
        }
        BatteryWidget{
          mainPopup: root.mainPopup
          anchors.verticalCenter: parent.verticalCenter
        }
        DateTime{
          anchors.verticalCenter: parent.verticalCenter
        }
      }
    }
  }
}