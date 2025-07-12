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
    
    property bool animating: false
    property bool onLeft: false
    property bool onRight: false

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
            console.log(root.screen.width, root.content.children[0].implicitWidth, root.content.posX)
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
            implicitWidth: root?.content?.children[0]?.implicitWidth || 100
            implicitHeight: root?.content?.children[0]?.implicitHeight || 100
            id: popupContent
            anchors.margins: 0

            opacity: 0.0
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
        Item {
            id: corners
            anchors.bottom: popupContent.top
            Item {
                id: topLeftCorner
                visible: !root.onLeft
                x: 0
                y: 0
                width: 45
                height: 45
                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "#EFEFEF"
                    layer.enabled: true
                    visible: true
                    layer.effect: MultiEffect {
                        maskSource: leftPopupMask
                        maskEnabled: true
                        maskInverted: true 
                    }
                }
                Rectangle {
                    id: leftPopupMask
                    width: parent.width
                    height: parent.height
                    color: "white"
                    visible: false
                    topRightRadius: parent.width / 2
                    layer.enabled: true
                }
            }
            Item {
                id: topRightCorner
                visible: !root.onRight
                x: popupWindow.implicitWidth - 45
                y: 0
                width: 45
                height: 45
                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "#EFEFEF"
                    layer.enabled: true
                    visible: true
                    layer.effect: MultiEffect {
                        maskSource: rightPopupMask
                        maskEnabled: true
                        maskInverted: true 
                    }
                }
                Rectangle {
                    id: rightPopupMask
                    width: parent.width
                    height: parent.height
                    color: "white"
                    visible: false
                    topLeftRadius: parent.width / 2
                    layer.enabled: true
                }
            }
            Item {
                id: bottomLeftCorner
                visible: root.onLeft
                x: 0
                y: popupWindow.implicitHeight - 45
                width: 45
                height: 45
                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "#EFEFEF"
                    layer.enabled: true
                    visible: true
                    layer.effect: MultiEffect {
                        maskSource: bottomLeftCornerMask
                        maskEnabled: true
                        maskInverted: true 
                    }
                }
                Rectangle {
                    id: bottomLeftCornerMask
                    width: parent.width
                    height: parent.height
                    color: "white"
                    visible: false
                    topLeftRadius: parent.width / 2
                    layer.enabled: true
                }
            }
            Item {
                id: bottomRightCorner
                visible: root.onRight
                x: popupWindow.implicitWidth - 45
                y: popupWindow.implicitHeight - 45
                width: 45
                height: 45
                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "#EFEFEF"
                    layer.enabled: true
                    visible: true
                    layer.effect: MultiEffect {
                        maskSource: bottomRightCornerMask
                        maskEnabled: true
                        maskInverted: true 
                    }
                }
                Rectangle {
                    id: bottomRightCornerMask
                    width: parent.width
                    height: parent.height
                    color: "white"
                    visible: false
                    topRightRadius: parent.width / 2
                    layer.enabled: true
                }
            }
            
        }
        
        Region {
            id: backgroundRegion
            x: 0
            y: 0
            width: popupWindow.implicitWidth
            height: popupWindow.implicitHeight
            intersection: Intersection.Xor
            regions: [corners]
            
        } 
        
    }
}