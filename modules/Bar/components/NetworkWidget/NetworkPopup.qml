pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.Widgets

Item {
  id: root
  width: 400
  height: networkMainCol.height
  Column {
    id: networkMainCol
    width: parent.width
    spacing: 20
    Column {
      id: ethernetCol
      width: parent.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      Text {
        text: "Ethernet"
        font.pixelSize: 18
      }
      RowLayout {
        spacing: 10
        Text {
          text: NetworkManager.getEthernetStatusIcon()
          font.family: "Material Symbols Rounded"
          font.pixelSize: 38
        }
        Column {
          Layout.fillWidth: true
          Layout.alignment: Qt.AlignVCenter
          Text {
            text: NetworkManager?.ethernet?.status != 20 ? NetworkManager?.ethernet?.name : "Not connected"
            clip: true
            font.pixelSize: NetworkManager?.ethernet?.status != 20 ? 14 : 20
          }
          Text {
            text: NetworkManager?.ethernet?.status != 70 && NetworkManager?.ethernet?.status != 20 ? NetworkManager?.ethernet?.ipv4 : "Assigning IP..."
            visible: NetworkManager?.ethernet?.status != 20
            clip: true
            font.pixelSize: 14
          }
        }
      }
    }
    Column {
      id: wifiCol
      width: parent.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 10

      Behavior on height {
        enabled: !NetworkManager.wifiActive
        NumberAnimation {
          duration: 200
        }
      }

      RowLayout {
        width: parent.width
        height: wifiSwitch.height 
        Text {
          text: "Wifi"
          font.pixelSize: 18
          Layout.fillWidth: true
          Layout.fillHeight: true
          
        }
        Row {
          Layout.fillHeight: true 
          Layout.alignment: Qt.AlignVCenter
          spacing: 5
          MaterialIconButton {
            id: refreshButton
            buttonIcon: "refresh"
            backgroundColor: "#aaaaaa"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
              NetworkManager.update()
              rotateUpdateAnim.running = true
            } 
            PropertyAnimation {
              id: rotateUpdateAnim
              target: refreshButton.contentItem
              property: "rotation"
              from: 0
              to: 360
              loops: 3
              duration: 1000
              running: false
            }
             
          }
          MaterialSwitch {
            id: wifiSwitch
            checked: NetworkManager.wifiActive
            onCheckedChanged: {
              NetworkManager.switchWifiPower()
            }
             
          }
        }
      }
      Column {
        visible: NetworkManager?.wifiActive
        height: childrenRect.height
        width: parent.width
        spacing: 5

        Behavior on height {
          NumberAnimation {
            duration: 200
          }
        }
        Repeater {
          model: NetworkManager?.wifiNetworksList
          RowLayout {
            id: wifiItem
            required property NetworkManager.WifiNetwork modelData
            width: parent.width
            Text {
              text: NetworkManager.getNetworkStrenghtIcon(parent?.modelData)
              font.family: "Material Symbols Rounded"
              font.pixelSize: 28
            }
            Text {
              text: parent?.modelData?.name
              Layout.alignment: Qt.AlignVCenter
              Layout.bottomMargin: 2
              Layout.maximumWidth: parent.width - 50
              font.pixelSize: 18
            }
            Item {
              Layout.fillWidth: true
            }
            Row {
              MaterialIconButton {
                buttonIcon: wifiItem.modelData.connected ? "link_off" : "link"
                onClicked: {
                  if(wifiItem.modelData.connected) {
                    NetworkManager.disconnectFormNetwork(wifiItem.modelData)
                  } else {
                    NetworkManager.connectToNetwork(wifiItem.modelData)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}