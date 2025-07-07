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
        color: "#252525"
        text: NetworkManager.activeNetwork ? NetworkIcons.getIconForStrength(NetworkManager.activeNetwork.strength) : "perm_scan_wifi"
    }
}