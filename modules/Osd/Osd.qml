pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import "../Bar/components"
import "root:/services" as Services

PopupWindow {
    property ShellScreen screen
    property var window
    property var content: content
    id: root
    width: content.width + 45
    height: content.height + 90
    color: "transparent"
    
    // Anclar a la ventana de la pantalla, posicionando en el borde derecho
    anchor.window: window
    anchor.rect.x: screen.width - width - 8  // 8px desde el borde derecho
    anchor.rect.y: screen.height / 2 - height / 2  // Centrado verticalmente

    visible: false
    
    property bool animating: false

    function open() {
        if (!root.animating && !root.visible) {
            closeAnimation.stop();
            
            root.animating = true;
            root.visible = true;
            openAnimation.start();
        }
    }
    
    function close() {
        if (!root.animating && root.visible) {
            openAnimation.stop();
            
            root.animating = true;
            closeAnimation.start();
        }
    }

    Connections{
        target: Services.Audio.currentSink.audio
        onVolumeChanged: {
            if (!root.visible) {
                root.open()
                hideTimer.stop()
                hideTimer.restart();
                hideTimer.start()
            }
        }
    }

    Connections{
        target: Services.Audio.currentSource.audio
        onVolumeChanged: {
            if (!root.visible) {
                root.open()
                hideTimer.stop()
                hideTimer.restart();
                hideTimer.start()
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            if (root.visible) {
                root.close();
            }
        }
    }

    SequentialAnimation {
        id: openAnimation
     
        ParallelAnimation {
           
            PropertyAnimation {
                target: content
                property: "x"
                from: content.width + 45 
                to: 45     
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
        onFinished: {
            root.animating = false;
            root.visible = true;
        }
    }
    
    SequentialAnimation {
        id: closeAnimation
        
        ParallelAnimation {
            
            PropertyAnimation {
                target: content
                property: "x"
                to: content.width + 45
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
        
        onFinished: {
            root.visible = false;
            root.animating = false;
        }
    }

    Rectangle {
        id: content
        width: 100
        height: 400
        color: "#EFEFEF"
        anchors.verticalCenter: parent.verticalCenter
        topLeftRadius: 10
        bottomLeftRadius: 10
        clip: true
        OsdContent{

        }
    }

    Item {
        id: corners
        anchors.left: content.left
        Item {
            id: topCorner
            x: content.width - 45 
            y: 0
            width: 45
            height: 45
            Rectangle {
                width: parent.width
                height: parent.height
                color: "#EFEFEF"
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskSource: topCornerMask
                    maskEnabled: true
                    maskInverted: true
                }
            }
            Rectangle {
                id: topCornerMask
                width: parent.width
                height: parent.height
                color: "white"
                bottomRightRadius: parent.width / 2
                layer.enabled: true
                visible: false
            }
        }
        Item {
            id: bottomCorner
            x: content.width - 45 
            y: content.height + 45
            width: 45
            height: 45
            Rectangle {
                width: parent.width
                height: parent.height
                color: "#EFEFEF"
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskSource: bottomCornerMask
                    maskEnabled: true
                    maskInverted: true
                }
            }
            Rectangle {
                id: bottomCornerMask
                width: parent.width
                height: parent.height
                color: "white"
                topRightRadius: parent.width / 2
                layer.enabled: true
                visible: false
            }
        }
    }

    mask: Region {
        x: content.x
        y: content.y
        width: content.width
        height: content.height
        intersection: Intersection.Intersect
    }
}