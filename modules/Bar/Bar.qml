import QtQuick 
import "components/Clock"
import "components/LauncherIcon"
import "components/Workspaces"
import "components/CurrentWindow"
import "components/Network"
import "components/Bluetooth"   
import "components/AudioManager"
import "components/Battery"

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
    NetworkItem {
        anchors.verticalCenter: parent.verticalCenter
        id: networkWidget
    }
    Bluetooth {
        anchors.verticalCenter: parent.verticalCenter
        id: bluetoothWidget
    }
    Audio {
        anchors.verticalCenter: parent.verticalCenter
        id: audioWidget
    }
    Battery {
        anchors.verticalCenter: parent.verticalCenter
        id: batteryWidget
    }
}