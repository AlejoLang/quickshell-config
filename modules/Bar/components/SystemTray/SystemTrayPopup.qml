pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    property list<QsMenuEntry> entries: []
    implicitWidth: 400
    implicitHeight: trayItemMenuColumn.height + 20
    color: "#EFEFEF"

    ColumnLayout {
        id: trayItemMenuColumn
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Repeater {
            model: root.entries
            Rectangle {
                id: trayItemMenuEntry
                required property var modelData
                width: root.width - 20
                height: trayItemMenuEntry.modelData.text ? trayItemMenuEntryText.height : trayItemMenuEntrySeparator.height
                color: "transparent"
                radius: 5
                Text {
                    id: trayItemMenuEntryText
                    text: trayItemMenuEntry.modelData.text || "-------------------------"
                    padding: 2
                    leftPadding: 5
                    clip: true
                    elide: Text.ElideRight
                    width: parent.width 
                    font.pixelSize: 16
                    visible: trayItemMenuEntry.modelData.text
                }
                Rectangle {
                    id: trayItemMenuEntrySeparator
                    width: parent.width
                    height: 2
                    color: "#252525"
                    visible: !trayItemMenuEntry.modelData.text
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: (event) => {
                        trayItemMenuEntry.modelData.triggered()
                        event.accepted = true;
                    }
                    onEntered: {
                        trayItemMenuEntry.color = "#D0D0D0";
                    }
                    onExited: {
                        trayItemMenuEntry.color = "transparent";
                    }
                }
            }
        }
    }
    
}