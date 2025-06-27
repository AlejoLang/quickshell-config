import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    spacing: 5
    Repeater {
        model: Hyprland.workspaces // Directly use the workspaces model
        Text {
            text: {modelData.active ? "radio_button_checked" : "radio_button_unchecked"}
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 20
            font.family: "Material Symbols Rounded"
            Layout.fillWidth: true
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    modelData.activate()    
                }
            }
        } 
    }
}