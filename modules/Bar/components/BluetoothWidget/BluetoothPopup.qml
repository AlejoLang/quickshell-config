pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.Widgets

Item {
  id: root
  width: 400
  height: bluetoothMainCol.height
  Column {
    id: bluetoothMainCol
    width: parent.width
    spacing: 15
    RowLayout {
      width: parent.width
      Text {
       text: "Bluteooth"
       font.pixelSize: 18
       Layout.fillWidth: true
      }
      MaterialSwitch {
        id: bluetoothEnablesSwitch
        checked: Bluetooth.powered
        onCheckedChanged: {
          Bluetooth.switchBluetoothPower()
        }
      }
    }
    Column {
      width: parent.width
      spacing: 5
      Repeater {
        model: Bluetooth.bluetoothDevices
        RowLayout {
          required property Bluetooth.Device modelData
          id: bluetoothItem
          width: parent.width
          Text {
            text: parent.modelData.icon
            font.pixelSize: 28
            font.family: "Material Symbols Rounded"
          }
          Text {
            text: parent.modelData.name
          }
          Item {
            Layout.fillWidth: true
          }
          Row {
            spacing: 10
            MaterialToggleButton {
              buttonIcon: "plug_connect"
              statusPressed: bluetoothItem.modelData.connected
              autoToggle: false
              useMaterialIcons: true
              onClicked: {
                if(bluetoothItem.modelData.connected) {
                  Bluetooth.disconnectFromDevice(bluetoothItem.modelData)
                } else {
                  Bluetooth.connectToDevice(bluetoothItem.modelData)
                }
              }
            }
            MaterialToggleButton {
              visible: bluetoothItem.modelData.paired
              buttonIcon: "attachment"
              autoToggle: false
              statusPressed: bluetoothItem.modelData.trusted
              useMaterialIcons: true
               onClicked: {
                if(bluetoothItem.modelData.trusted) {
                  Bluetooth.untrustDevice(bluetoothItem.modelData)
                } else {
                  Bluetooth.trustDevice(bluetoothItem.modelData)
                }
              }
            } 
            MaterialIconButton {
              visible: bluetoothItem.modelData.paired
              buttonIcon: "delete"
              backgroundColor: "transparent"
              textColor: "#252525"
              onClicked: {
                Bluetooth.removeDevice(bluetoothItem.modelData)
              }
            }
          }
          
        }
      }
    }
  }
}