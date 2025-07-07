import QtQuick 
import "components/Clock"
import "components/LauncherIcon"
import "components/Workspaces"
import "components/CurrentWindow"
import "components/Network"
import "components/Bluetooth"   
import "components/AudioManager"
import "components/Battery"

Item {
    id: root
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    implicitWidth: parent.implicitWidth
    implicitHeight: 40
    
    Rectangle {
        color: "transparent"
        implicitWidth: parent.implicitWidth
        implicitHeight: parent.implicitHeight

        anchors{
            fill: parent
            leftMargin: 16
            rightMargin: 16
        }

        Row {
            anchors.fill: parent
            width: parent.implicitWidth - 32
            height: parent.implicitHeight

            Row {
                id: leftChunk
                layoutDirection: Qt.LeftToRight
                width: parent.width / 3;
                height: parent.height
                spacing: 15

                LauncherIcon {
                    id: launcherIcon
                    anchors.verticalCenter: parent.verticalCenter
                } 
                Workspaces {
                    id: workspaces
                    anchors.verticalCenter: parent.verticalCenter
                }
                CurrentWindow {
                    id: currentWindow
                    anchors.verticalCenter: parent.verticalCenter
                }
            } 

            Row {
                id: centerChunk
                width: parent.width / 3;
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: "Center"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Row {
                id: rightChunk
                layoutDirection: Qt.RightToLeft
                width: parent.width / 3;
                height: parent.height
                spacing: 15

                Clock {
                    id: clock
                    anchors.verticalCenter: parent.verticalCenter
                }
                Battery {
                    id: battery
                    anchors.verticalCenter: parent.verticalCenter
                }
                Bluetooth {
                    id: bluetooth
                    anchors.verticalCenter: parent.verticalCenter
                }
                Network {
                    id: network
                    anchors.verticalCenter: parent.verticalCenter
                }
                Audio {
                    id: audioManager
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}