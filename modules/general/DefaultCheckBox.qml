import QtQuick
import QtQuick.Controls

CheckBox {
    id: root
    checked: false 

    indicator: Text {
        text: "check"
        font.family: "Material Symbols Rounded"
        font.pixelSize: root.height - 5
        font.bold: true
        color: "white"
        anchors.centerIn: parent
        visible: root.checked
    }

    background: Rectangle {
        color: root.checked ? "#237dc7" : "transparent"
        radius: parent.height / 4
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        border.color: root.checked ? "#237dc7" : "#252525"
        border.width: 1
    }
}