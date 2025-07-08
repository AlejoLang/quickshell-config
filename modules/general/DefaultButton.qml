import QtQuick
import QtQuick.Controls

Button {
    id: root

    property color backgroundColor: "#000000"
    property color text_color: "#FFFFFF"

    contentItem: Text {
        id: buttonText
        text: root.text
        color: root.text_color
        font.family: "Material Symbols Rounded"
        font.pixelSize: 24
        anchors.verticalCenter: buttonBackground.verticalCenter
        anchors.horizontalCenter: buttonBackground.horizontalCenter
        anchors.horizontalCenterOffset: 2
    }

    background: Rectangle {
        id: buttonBackground
        color: root.backgroundColor
        implicitWidth: buttonBackground.height
        implicitHeight: buttonText.height
        radius: buttonText.font.pixelSize / 2
        anchors.centerIn: parent
    }

}