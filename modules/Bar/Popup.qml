pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

PopupWindow {
  id: root 
  property Item content: null
  property Item pendingContent: null
  property Item pendingAnchor: null
  property Item bar
  property PanelWindow window
  property bool isReplacing: false
  property real targetX: 0
  property real targetY: 0
  property real targetWidth: content?.width + 20 ?? 1
  property real targetHeight: content?.height + 20 ?? 1
  
  implicitHeight: Math.max(targetHeight, 1)
  implicitWidth: Math.max(targetWidth, 1)
  visible: content !== null
  anchor.window: window
  anchor.rect.x: targetX
  anchor.rect.y: targetY

  color:"transparent"

  SequentialAnimation {
    id: openAnimation
    
    PropertyAnimation {
      target: root
      property: "targetY"
      from: -root.content.height
      to: root.bar.height + 10
      duration: 100
    }
    PropertyAnimation {
      target: wrapperRect
      property: "opacity"
      from: 0
      to: 1
      duration: 50
    }
    onStarted: {
      root.content.visible = true
    }
   
    onFinished: {
      root.visible = true
    }
  }

  SequentialAnimation {
    id: closeAnimation
    PropertyAnimation {
      target: wrapperRect
      property: "opacity"
      from: 1
      to: 0
      duration: 100
    }
    PropertyAnimation {
      target: root
      property: "targetY"
      from: root.bar.height + 10
      to: -root.content.height
      duration: 100
    }
    onFinished: {
      root.visible = false
      root.content.visible = false
      root.content = null
    }
  }
  ParallelAnimation {
    id: changeItemAnimation
    property Item newItem
    property real newX
    PropertyAnimation {
      target: root
      property: "targetHeight"
      to: changeItemAnimation.newItem.height + 20
      duration: 200
      easing.type: Easing.InOutQuad
    }
    PropertyAnimation {
      target: root
      property: "targetWidth"
      to: changeItemAnimation.newItem.width + 20
      duration: 200
      easing.type: Easing.InOutQuad
    }
    PropertyAnimation {
      target:root
      property: "targetX"
      to: changeItemAnimation.newX
      duration: 200
      easing.type: Easing.InOutQuad
    }
    PropertyAnimation {
      target: wrapperRect
      property: "opacity"
      from: 0
      to: 1
      duration: 200
      easing.type: Easing.InOutQuad
    }
    onFinished: {
      root.content = newItem
      root.content.visible = true
      wrapperRect.height = root.content.height + 20
      wrapperRect.width = root.content.width + 20
      root.isReplacing = false
    }
  }

  function calculateX(newContent: Item, anchorItem: Item): real {
    let anchor = anchorItem ?? newContent?.parent
    if (anchor) {
      let anchorX = window.itemPosition(anchor).x
      let anchorWidth = anchor.width
      let popupWidth = newContent.width + 20
      let x = anchorX + (anchorWidth / 2) - (popupWidth / 2)
      
      if (x < 16) {
        x = 16;
      }
      if (window && x + popupWidth > window.width - 16) {
        x = window.width - popupWidth - 16
      }
      return x
    }
    return 100
  }

  function replaceContent(newContent: Item, anchorItem: Item) { 
    root.isReplacing  = true
    root.content.visible = false
    wrapperRect.opacity = 0
    changeItemAnimation.newX = calculateX(newContent, anchorItem)

    changeItemAnimation.newItem = newContent 
    changeItemAnimation.running = true
  }
  
  function setContent(newContent: Item, anchorItem: Item) {
    if(newContent === root.content) return
    if(root.content) {
      replaceContent(newContent, anchorItem);
      return;
    }
    
    root.isReplacing = false
    root.targetX = calculateX(newContent, anchorItem)
    
    root.content = newContent
    root.visible = true
    openAnimation.running = true; 
  }

  function close() {
    closeAnimation.running = true
  }
  
  Rectangle {
    id: wrapperRect
    anchors.fill: parent
    radius: 10
    color: "transparent"
     
    Rectangle {
      color: "transparent"
      id: contentWrapper
      implicitWidth: root.content ? root.content.width : 0
      implicitHeight: root.content ? root.content.height : 0
      anchors.centerIn: parent
      children: root.content ? [root.content] : []
    }
  } 
}