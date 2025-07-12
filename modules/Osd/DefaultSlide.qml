import QtQuick
import QtQuick.Controls

Slider {
    id: root

    property real minValue: 0
    property real maxValue: 100
    

    from: root.minValue
    to: root.maxValue
    stepSize: 1

    handle: Rectangle {
        width: 0
        height: 0
    }
    
    background: Rectangle {
        color: "#222"
        radius: 10
        anchors.fill: parent
        width: parent.width
        height: parent.height
        clip: true
        Rectangle {
            clip: true
            color: "#237dc7"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.max(parent.height * root.position, parent.width)
            width: parent.width
            radius: 10
        }
    } 
}