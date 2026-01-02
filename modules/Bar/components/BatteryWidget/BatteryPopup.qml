pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.Widgets

Item {
  id: root
  implicitHeight: batteryPopupCol.height
  implicitWidth: 300
  Column {
    id: batteryPopupCol
    width: parent.width
    height: childrenRect.height
    Column {
      id: batteryScreenSection
      width: parent.width
      spacing: 5
      Text {
        text: "Screen Birghtness"
        font.pixelSize: 18
      }
      Repeater {
        model: Display.displays
        Column {
          id: displayControlCol
          required property Display.DisplayComp modelData
          width: parent.width - 20
          anchors.horizontalCenter: parent.horizontalCenter
          Text {
            text: parent.modelData.name
          }
          RowLayout {
            width: parent.width
            spacing: 10
            MaterialSlider {
              id: brightnessSlider
              Layout.fillWidth: true
              Layout.preferredHeight: 36
              stepSize: 0.01
              value: displayControlCol.modelData.brightness
              onValueChanged: {
                Display.setBrightness(displayControlCol.modelData ,brightnessSlider.value)
              }
            }
            Text {
              text: Math.round(brightnessSlider.value * 100)
              Layout.preferredWidth: 30
              Layout.alignment: Qt.AlignRight
            }
          }
        }
      }
    } 
    Column {
      id: batteryInfoCol
      width: parent.width
      spacing: 5
      visible: Battery.battery
      Text {
        text: "Battery info"
        font.pixelSize: 18
      }
      Column {
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
          text: "Status: " + Battery.getBatteryState()
        }
        Text {
          text: "Rate: " + Battery.getBatteryRate() + " W/h"
          visible: Battery.batteryIsDischarging() || Battery.batteryIsCharging()
        }
        Text {
          property int emptyTime: Battery.getTimeToEmpty()
          text: "Time to empty: " + Math.round(emptyTime / 3600) + " h " + Math.round((emptyTime % 3600) / 60) + " m " 
          visible: Battery.batteryIsDischarging()
        }
        Text {
          property int fullTime: Battery.getTimeToFull()
          text: "Time to full: " + Math.round(fullTime / 3600) + " h " + Math.round((fullTime % 3600) / 60) + " m " 
          visible: Battery.batteryIsCharging()
        }
      }
    }
  }
}