pragma ComponentBehavior: Bound
import QtQuick
import qs.modules.Bar
import qs.services

Item {
  id: root
  implicitWidth: batteryRow.width
  implicitHeight: batteryRow.height
  property Popup mainPopup
   Row {
    id: batteryRow
    spacing: 5
    Text {
      text: Battery.getBatteryIcon()
      font.family: "Material Symbols Rounded"
      font.pixelSize: 24
      anchors.verticalCenter: parent.verticalCenter
    }
    Text {
      text: Math.round(Battery.getBatteryPercentage())
      anchors.verticalCenter: parent.verticalCenter
    }
  }
  MouseArea {
    anchors.fill: parent
    onClicked : {
      if(root.mainPopup.content == batteryPopup) {
        root.mainPopup.close();
        return;
      }
      root.mainPopup.setContent(batteryPopup, root);
    }
  }
  BatteryPopup {
    id: batteryPopup
    visible: false
  }
}