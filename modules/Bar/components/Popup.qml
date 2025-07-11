pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland

Scope {
    property ShellScreen screen
    property PopupContent content
    property var window
    property bool visible
    property bool isHoverPopup
    property real absX
    property real absY

    id: root

    function contains(point) {
        if (point.x >= root.content.posX && point.x <= root.content.posX + root.content.implicitWidth &&
            point.y >= root.content.posY && point.y <= root.content.posY + root.content.implicitHeight) {
            return true;
        }
        return false;
    }
    
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
        root.content.posY = locOw.y + root.content.owner.height ;
        if (root.content.posX < window.x + 10) {
            root.content.posX = window.x + 10;
        } else if (root.content.posX + root.content.children[0].implicitWidth > window.x + window.width - 10) {
            root.content.posX = window.x + window.width - root.content.children[0].implicitWidth - 10;
        }
        root.absX = locOw.x + (root.content.owner.width / 2) - (root.content.children[0].implicitWidth / 2);
        root.absY = locOw.y + root.content.owner.height;
    }
   
    PopupWindow {
        id: popupWindow
        implicitHeight: popupContent.implicitHeight
        implicitWidth: popupContent.implicitWidth
        anchor.window: root.window
        anchor.rect.x: root.content?.posX || 0
        anchor.rect.y: root.content?.posY || 0
        visible: root.visible
        color: "transparent"
        Item {
            implicitWidth: root?.content?.children[0]?.implicitWidth || 100
            implicitHeight: root?.content?.children[0]?.implicitHeight || 100
            id: popupContent
        }
    }
}