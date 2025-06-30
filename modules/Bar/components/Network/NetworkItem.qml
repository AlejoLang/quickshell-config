import QtQuick
import "root:/services/"
import "root:/utils/networkIcons.js" as NetworkIcons

Row {
    id: root
    spacing: 5
    Text {
        id: networkIcon
        font.family: "Material Symbols Rounded"
        font.pixelSize: 24
        color: "white"
        text: NetworkManager.activeNetwork ? NetworkIcons.getIconForStrength(NetworkManager.activeNetwork.strength) : "perm_scan_wifi"
    }
    Text {
        id: networkText
        anchors.bottom: networkIcon.bottom
        anchors.bottomMargin: 4
        text: NetworkManager.activeNetwork ? NetworkManager.activeNetwork.name : "No Network"
        font.pixelSize: 16
        font.family: "CaskaydiaCove Nerd Font"
        color: "white"
    }
}