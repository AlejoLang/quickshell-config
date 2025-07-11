import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell
import "../"

Rectangle {
    color: "transparent"
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
    RowLayout {
        spacing: 5
        Repeater {
            model: SystemTray.items
            Rectangle {
                id: trayItem
                required property var modelData
                width: 30
                height: 30
                radius: 10
                color: modelData.color || "#8a8a8a"
                
                Image {
                    source: trayItem.modelData.icon || "qrc:/icons/unknown.png"
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                }

                QsMenuOpener {
                    id: trayItemMenuOpener
                    menu: trayItem.modelData.menu
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log(trayItemMenuOpener.children.values)
                    }
                    hoverEnabled: true
                    onEntered: {
                        if (popup.visible) {
                            if (popup.content === trayItemMenuContent) {
                                return;
                            } else {
                                popup.changeContent(trayItemMenuContent);
                            }
                        } else {
                            popup.changeContent(trayItemMenuContent);
                            popup.visible = true;
                        }
                    }
                }

                property PopupContent trayItemMenuContent: PopupContent {
                    width: trayItemMenu.width
                    height: trayItemMenu.height
                    id: trayItemMenuContent
                    owner: trayItem 
                    SystemTrayPopup {
                        id: trayItemMenu
                        entries: trayItemMenuOpener.children.values
                    }
                }
            }
        }
    }
}