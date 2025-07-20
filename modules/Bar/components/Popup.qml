pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import QtQuick.Effects

Scope {
    property ShellScreen screen
    property PopupContent content
    property var window
    property bool visible
    property bool isHoverPopup
    property real absX
    property real absY
    property real popupY: popupContent.y
    property real popupHeight: popupContent.implicitHeight
    
    property bool animating: false
    property bool onLeft: false
    property bool onRight: false

    id: root
    
    property var popupController: null  // Reference to the popup controller

    function open() {
        popupContent.children = content;
        closeAnimation.stop();
        if (!root.animating) {
            console.log("Opening popup");
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
        console.log("sad")
        
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
        }
        onStarted: {
            root.animating = true;
            popupWindow.visible = true;
        } 
        onFinished: root.animating = false
    }
    
    SequentialAnimation {
        id: closeAnimation
        
        ParallelAnimation {
            PropertyAnimation {
                target: popupContent
                property: "y"
                from: 0
                to: -popupContent.implicitHeight
                duration: 300
                easing.type: Easing.OutCubic
            }
            
        }
        onStarted: {
            root.animating = true;
        }
        onFinished: {
            root.visible = false;
            root.animating = false;
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
        if (openAnimation.running) {
            openAnimation.stop();
            root.animating = false;
        }
        root.onLeft = false;
        root.onRight = false;

        if(root.content) {
            root.content.parent = null;
        }
        root.content = newContent;
        if(root.content) {
            root.content.parent = popupContent;
        }
        const locOw = window.itemPosition(root.content.owner);
        root.content.posX = locOw.x + (root.content.owner.width / 2) - ((root.content.children[0].implicitWidth+90) / 2);
        root.content.posY = locOw.y + root.content.owner.height;
        if (root.content.posX < 16) {
            root.onLeft = true;
            root.content.posX =  8;
        } else if (root.content.posX + root.content.children[0].implicitWidth > root.screen.width - 8) {
            root.onRight = true;
            root.content.posX = root.screen.width - root.content.children[0].implicitWidth - (45 + 8);
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
        implicitHeight: popupContent.implicitHeight + 45
        implicitWidth: popupContent.implicitWidth + (root.onLeft || root.onRight ? 45 : 90)
        anchor.window: root.window
        anchor.rect.x: root.content?.posX || 0
        anchor.rect.y: root.content?.posY || 0
        visible: root.visible
        color: "transparent"
        
        Rectangle {
            bottomLeftRadius: root.onLeft ? 0 : 10
            bottomRightRadius: root.onRight ? 0 : 10
            color: "#EFEFEF"
            implicitWidth: root?.content?.children[0]?.implicitWidth || 0
            implicitHeight: root?.content?.children[0]?.implicitHeight || 0
            id: popupContent
            anchors.margins: 0
            visible: root.visible

            opacity: 1
            y: 0
            
            states: [
                State {
                    name: "leftAligned"
                    when: root.onLeft
                    AnchorChanges {
                        target: popupContent
                        anchors.left: popupContent.parent.left
                        anchors.right: undefined
                        anchors.horizontalCenter: undefined
                    }
                    
                },
                State {
                    name: "rightAligned"
                    when: root.onRight && !root.onLeft
                    AnchorChanges {
                        target: popupContent
                        anchors.left: undefined
                        anchors.right: popupContent.parent.right
                        anchors.horizontalCenter: undefined
                    }
                },
                State {
                    name: "centerAligned"
                    when: !root.onLeft && !root.onRight
                    AnchorChanges {
                        target: popupContent
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: popupContent.parent.horizontalCenter
                    }
                }
            ]
        }
        
        mask: root.visible ? backgroundRegion : nullR
        Region {
            id: backgroundRegion
            x: popupContent.x
            y: popupContent.y
            width: popupContent.implicitWidth
            height: popupContent.implicitHeight
            intersection: Intersection.Intersect
        }
        Region {
            id: nullR
            x: 0
            y: 0
            width: 0
            height: 0
            intersection: Intersection.Intersect
        }
    }
}