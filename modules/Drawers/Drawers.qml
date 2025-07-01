import Quickshell
import QtQuick
import QtQuick.Effects
import "../Bar"

Variants {
    model: Quickshell.screens
    id: root
    PanelWindow {
        id: panelWindow
        property var modelData
        property PopupWindow openedPopup
        screen: modelData
        anchors {
            top: true
            left: true
            right: true
        }
        color: "#252525"
        implicitHeight: 40
        MouseArea {
            propagateComposedEvents: true
            x: 0
            y: 0
            width: panelWindow.modelData.width
            height: panelWindow.modelData.height
            onClicked: (event) => {
                if(!panelWindow.openedPopup) {
                    return
                }
                const checkWidth = event.x >= panelWindow.openedPopup.anchor.rect.x && event.x <= (panelWindow.openedPopup.anchor.rect.x + panelWindow.openedPopup.implicitWidth);
                const checkHeight = event.y >= panelWindow.openedPopup.anchor.rect.y && event.y <= (panelWindow.openedPopup.anchor.rect.y + panelWindow.openedPopup.implicitHeight);
                if(checkHeight && checkWidth) {
                    return
                } else {
                    event.accepted = false
                    panelWindow.openedPopup.visible = false;
                    panelWindow.openedPopup = null;
                }
            } 
        } 
        Bar{}
    }
}