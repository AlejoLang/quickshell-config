pragma ComponentBehavior: Bound
import QtQuick
import qs.services
import qs.modules.Bar

Item {
  id: root
  property Popup mainPopup
  implicitWidth: networkIcon.width
  implicitHeight: networkIcon.height
  Text {
    id: networkIcon
    text: NetworkManager.getActiveNetworkStrenghtIcon()
    font.family: "Material Symbols Rounded"
    font.pixelSize: 24
    anchors.verticalCenter: parent.verticalCenter
  }
  MouseArea {
    anchors.fill: parent
    onClicked: {
      if(root.mainPopup.content == networkPopup) {
        root.mainPopup.close();
        return;
      }
      root.mainPopup.setContent(networkPopup, root);
    }
  }
  NetworkPopup {
    id: networkPopup
    visible: false
  }
}