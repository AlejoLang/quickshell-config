import QtQuick

Text {
    id: launcherIcon
    font.family: "Material Symbols Rounded"
    font.pixelSize: 28
    textFormat: Text.StyledText
    text: "apps"
    anchors.verticalCenter: parent.verticalCenter
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // send message to console
            console.log("Click!")
        }
    }  
}