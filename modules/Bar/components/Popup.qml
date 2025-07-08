pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland

Scope {
    property ShellScreen screen
    property PopupContent content
    property var window
    property bool visible

    id: root
    
    function changeContent(newContent: PopupContent) {
        if(root.content) {
            root.content.parent = null;
        }
        root.content = newContent;
        if(root.content) {
            root.content.parent = popupContent;
        }
        const locOw = window.itemPosition(root.content.owner);
        root.content.posX = locOw.x + (root.content.owner.width / 2) - (root.content.children[0].implicitWidth / 2);
        root.content.posY = locOw.y + root.content.owner.height + 10;
        if (root.content.posX < window.x + 10) {
            root.content.posX = window.x + 10;
        } else if (root.content.posX + root.content.children[0].implicitWidth > window.x + window.width - 10) {
            root.content.posX = window.x + window.width - root.content.children[0].implicitWidth - 10;
        }
    }
   
    PopupWindow {
        id: popupWindow
        implicitHeight: popupContent.implicitHeight
        implicitWidth: popupContent.implicitWidth
        anchor.window: root.window
        anchor.rect.x: root.content.posX
        anchor.rect.y: root.content.posY
        visible: root.visible
        color: "transparent"
        Item {
            implicitWidth: root.content.children[0].implicitWidth 
            implicitHeight: root.content.children[0].implicitHeight
            id: popupContent
        }
    }
    
    HyprlandFocusGrab {
        active: root.visible
        windows: [popupWindow, root.window]
        onCleared: {
            root.visible = false
            root.changeContent(null)
        }
    }
    
}