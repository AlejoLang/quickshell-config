import QtQuick
import "root:/services/"

Row {
    spacing: 5
    Repeater {
        model: Hyprland.workspaces // Directly use the workspaces model
        Text {
            text: {modelData.active ? "radio_button_checked" : "radio_button_unchecked"}
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 20
            font.family: "Material Symbols Rounded"
            color: "white"
            MouseArea {
                propagateComposedEvents: true
                anchors.fill: parent
                onClicked: (event) => {
                    modelData.activate()    
                    event.accepted = false
                }
            }
        } 
    }
}