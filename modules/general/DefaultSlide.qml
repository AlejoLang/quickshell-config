import QtQuick
import QtQuick.Controls

Slider {
    id: root

    property real minValue: 0
    property real maxValue: 100
    orientation: Qt.Horizontal 

    from: root.minValue
    to: root.maxValue
    stepSize: 1

    handle: Rectangle {
        width: 0
        height: 0
    }
    onPositionChanged: {
        console.log("Slider position changed:", position);
        console.log(width * position);
        console.log(height * position);
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
            anchors{
                left: root.orientation == Qt.Horizontal ? parent.left : parent.left
                right: root.orientation == Qt.Horizontal ? null : parent.right
                top: root.orientation == Qt.Horizontal ? parent.top : null
                bottom: root.orientation == Qt.Horizontal ? null : parent.bottom
            }
            height: root.orientation == Qt.Horizontal ? parent.height : Math.max(parent.height * root.position, parent.width)
            width: root.orientation == Qt.Horizontal ? Math.max(parent.width * root.position, parent.height) : parent.width
            radius: 10
        }
    } 
}