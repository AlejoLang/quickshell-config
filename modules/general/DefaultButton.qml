import QtQuick
import QtQuick.Controls

Button {
    id: root

    property color background_color: "#000000"
    property color text_color: "#FFFFFF"
    property color hover_color: "#444444"
    property int radius: 5
    property int pixel_size: height - 10

    contentItem: Text {
        id: buttonText
        text: root.text
        color: root.text_color
        font.bold: root.font.bold
        font.family: "Material Symbols Rounded"
        font.pixelSize: root.pixel_size
        anchors.verticalCenter: buttonBackground.verticalCenter
        anchors.horizontalCenter: buttonBackground.horizontalCenter
    }

    background: Rectangle {
        id: buttonBackground
        color: root.background_color
        width: parent.height
        height: parent.height
        radius: root.radius
        anchors.centerIn: parent
    }

}