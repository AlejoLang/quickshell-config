import QtQuick
import "root:/modules/general/"
import "root:/services/"

Column {
    id: root
    required property var node
    width: parent.width
    padding: 10
    Row {
        spacing: 10
        Text {
            font.family: "Material Symbols Rounded"
            font.pixelSize: 24
            color: "white"
            text: root.node.isSink ? "headphones" : "mic"
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: {
                if (root.node.description) {
                    if (root.node.description.length > 50) {
                        return root.node.description.substr(0, 50) + "...";
                    } else {
                        return root.node.description;
                    }
                } else {
                    return "Unnamed Node";
                }
            }
            font.pixelSize: 16
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Slide {
        id: volumeSlider
        height: 10
        width: parent.width - 100
        onProgressChanged: {
            Audio.setNodeVolume(root.node.id, volumeSlider.progress);
        }
    } 
} 
