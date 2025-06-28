import QtQuick 
import "components/Clock"
import "components/LauncherIcon"
import "components/Workspaces"
import "components/CurrentWindow"

Row {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 10
    width: parent.implicitWidth
    spacing: 10
    LauncherIcon {
        id: launcherIcon
        anchors.verticalCenter: parent.verticalCenter
    }
    Workspaces {
        id: workspacesWidget
        anchors.verticalCenter: parent.verticalCenter
    }
    CurrentWindow {
        anchors.verticalCenter: parent.verticalCenter
        id: currentWindowWidget
    } 
    Clock {
        anchors.verticalCenter: parent.verticalCenter
        id: clockWidget
    }
}