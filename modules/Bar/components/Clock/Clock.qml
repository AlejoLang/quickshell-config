import QtQuick
// qmllint disable import
import "root:/services/"

Column {
    anchors.verticalCenter: parent.verticalCenter
    Text {
        id: clockIcon
        font.family: "Material Symbols Rounded"
        font.pixelSize: 20
        textFormat: Text.StyledText
        text: "calendar_month"
        anchors.verticalCenter: parent.verticalCenter
    }
    Text {
        // qmllint disable unqualified
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        anchors.left: clockIcon.right
        text: Time.time
        font.pixelSize: 18
    }
}