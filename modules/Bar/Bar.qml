import Quickshell
import QtQuick 
import "components/Clock"

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 5
    color: "red"
    height: 30
    Clock {
        id: clockWidget
    }
}