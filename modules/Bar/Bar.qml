pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
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
    RowLayout {
      id: barLayout
      anchors.fill: parent
      anchors.verticalCenter: parent.verticalCenter
      Row {
        id: leftBarModule
        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        Layout.maximumWidth: parent.width / 3
        Layout.minimumWidth: parent.width / 3
        spacing: 20
        Workspaces {
          id: workspaces 
          mainPopup: root.mainPopup
        }
        CurrentWindow {
          id: currentWindow
        }
        Item {
          Layout.fillWidth:true
        }
      }
      RowLayout {
        id: centerBarModule
        Layout.alignment: Qt.AlignCenter
        Layout.fillWidth: true
        spacing: 20
        MultimediaWidget {
          Layout.alignment: Qt.AlignCenter
          mainPopup: root.mainPopup
        }
      }
      RowLayout {
        id: rightBarModule
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        Layout.maximumWidth: parent.width / 3
        Layout.minimumWidth: parent.width / 3
        spacing: 20
        Item {
          Layout.fillWidth:true
        }
        AudioWidget {
          mainPopup: root.mainPopup
        }
        NetworkWidget{
          mainPopup: root.mainPopup
        }
        BluetoothWidget {
          mainPopup: root.mainPopup
        }
        BatteryWidget{
          mainPopup: root.mainPopup
        }
        DateTime{
          Layout.alignment: Qt.AlignVCenter
        }
      }
    }
  }
}