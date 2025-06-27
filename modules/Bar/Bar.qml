import Quickshell
import QtQuick 
import "components/Clock"
import "components/LauncherIcon"
import "components/Workspaces"

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 5
    color: "red"
    height: 40
    radius: 5
    LauncherIcon {
        id: launcherIcon
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
    }
    Workspaces {
        id: workspacesWidget
        anchors.left: launcherIcon.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
    }
    Clock {
        anchors.left: workspacesWidget.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        id: clockWidget
    }
}