pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import QtQuick.Effects

Item {
    id: root

    required property ShellScreen screen
    required property Item bar

    anchors.fill: parent

    Rectangle {
        id: borderRect
        anchors.fill: parent
        layer.enabled: true 
        visible: true 
        color: "#efefef"
        layer.effect: MultiEffect {
            maskSource: mask
            maskEnabled: true
            maskInverted: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }
    }

    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            anchors.topMargin: root.bar.implicitHeight
            radius: 20
            antialiasing: false
        }
    }
}