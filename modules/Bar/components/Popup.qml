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
    
    property bool animating: false

    id: root
    
    function open() {
        if (!root.animating) {
            closeAnimation.stop();
            
            root.animating = true;
            root.visible = true;
            openAnimation.start();
        }
    }
    
    function close() {
        if (!root.animating) {
            openAnimation.stop();
            
            root.animating = true;
            closeAnimation.start();
        }
    }
    
    function switchContent(newContent: PopupContent) {
        openAnimation.stop();
        closeAnimation.stop();
        
        changeContent(newContent);
        
        if (root.visible) {
            root.animating = false;
            popupContent.opacity = 1.0;
            popupContent.y = 0;
        }
    }
    
    SequentialAnimation {
        id: openAnimation
        
        ParallelAnimation {
            PropertyAnimation {
                target: popupContent
                property: "y"
                from: -popupContent.implicitHeight
                to: 0
                duration: 200
                easing.type: Easing.OutCubic
            }
            
            PropertyAnimation {
                target: popupContent
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        
        onFinished: root.animating = false
    }
    
    SequentialAnimation {
        id: closeAnimation
        
        ParallelAnimation {
            PropertyAnimation {
                target: popupContent
                property: "opacity"
                to: 0.0
                duration: 150
                easing.type: Easing.InCubic
            }
            
            PropertyAnimation {
                target: popupContent
                property: "y"
                to: -popupContent.implicitHeight
                duration: 150
                easing.type: Easing.InCubic
            }
        }
        
        onFinished: {
            root.visible = false;
            root.animating = false;
            popupContent.y = -popupContent.implicitHeight;
        }
    }

    function contains(point) {
        if (point.x >= root.content.posX && point.x <= root.content.posX + root.content.implicitWidth &&
            point.y >= root.content.posY && point.y <= root.content.posY + root.content.implicitHeight) {
            return true;
        }
        return false;
    }
    
    function changeContent(newContent: PopupContent) {
        if (closeAnimation.running) {
            closeAnimation.stop();
            root.animating = false;
        }
        
        if(root.content) {
            root.content.parent = null;
        }
        root.content = newContent;
        if(root.content) {
            root.content.parent = popupContent;
        }
        const locOw = window.itemPosition(root.content.owner);
        root.content.posX = locOw.x + (root.content.owner.width / 2) - (root.content.children[0].implicitWidth / 2);
        root.content.posY = locOw.y + root.content.owner.height;
        if (root.content.posX < window.x + 10) {
            root.content.posX = window.x + 10;
        } else if (root.content.posX + root.content.children[0].implicitWidth > window.x + window.width - 10) {
            root.content.posX = window.x + window.width - root.content.children[0].implicitWidth - 10;
        }
        root.absX = locOw.x + (root.content.owner.width / 2) - (root.content.children[0].implicitWidth / 2);
        root.absY = locOw.y + root.content.owner.height;
        
        if (root.visible) {
            popupContent.opacity = 1.0;
            popupContent.y = 0;
        }
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
            
            opacity: 0.0
            y: 0
            
        }
        
    }
}