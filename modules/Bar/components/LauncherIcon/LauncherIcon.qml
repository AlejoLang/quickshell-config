import QtQuick

Text {
    id: launcherIcon
    font.family: "Material Symbols Rounded"
    color: "#252525"
    font.pixelSize: 28
    textFormat: Text.StyledText
    text: "apps"
    anchors.verticalCenter: parent.verticalCenter
    MouseArea {
        propagateComposedEvents: true
        anchors.fill: parent
        onClicked: (event) => {
            // send message to console
            console.log("Click!")
            event.accepted = false
        }
    }  
}