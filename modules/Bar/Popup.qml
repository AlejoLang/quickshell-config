pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

PopupWindow {
  id: root 
  property Item content: null
  property Item bar
  property PanelWindow window
  property bool isReplacing: false
  property bool opening_closing
  property real targetHeight: 1
  property real targetWidth: 1
  property real targetX: 0
  property real targetY: 0 
  
  implicitHeight: targetHeight
  implicitWidth:  targetWidth 
  anchor.window: window
  anchor.rect.x: targetX
  anchor.rect.y: root.bar.height ?? 0
  color: "transparent"

  ParallelAnimation {
    id: openAnimation
    property Item content 
    PropertyAnimation {
      target: root
      property: "targetY"
      from: -openAnimation.content.height
      to: 10
      duration: 100
    }
    PropertyAnimation {
      target: wrapperRect
      property: "opacity"
      from: 0
      to: 1
      duration: 100
    }
    onStarted: {
      root.content = openAnimation.content
      root.visible = true
      root.content.visible = true
      root.opening_closing = true
    }
    onFinished: {
      root.opening_closing = false
    }
  }

  ParallelAnimation {
    id: closeAnimation
    PropertyAnimation {
      target: root
      property: "targetY"
      from: 10
      to: -root.content.height
      duration: 100
    }
    PropertyAnimation {
      target: wrapperRect
      property: "opacity"
      from: 1
      to: 0
      duration: 100
    }
    onStarted: {
      root.opening_closing = true
    }
    
    onFinished: {
      root.visible = false
      root.content.visible = false
      root.content = null
      root.opening_closing = false
    }
  }
  ParallelAnimation {
    id: changeItemAnimation
    property Item newItem
    property real newX
    PropertyAnimation {
      target: root
      property: "targetHeight"
      to: changeItemAnimation.newItem.height + 30
      duration: 300
    }
    PropertyAnimation {
      target: root
      property: "targetWidth"
      to: changeItemAnimation.newItem.width + 20
      duration: 300
    }
    PropertyAnimation {
      target:root
      property: "targetX"
      to: changeItemAnimation.newX
      duration: 300
    }
    onStarted: {
      //root.content.visible = false
      wrapperRect.opacity = 0
    }
    onFinished: {
      root.isReplacing = false
      root.content = newItem
      root.content.visible = true
      wrapperRect.opacity = 1
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
    changeItemAnimation.newX = calculateX(newContent, anchorItem)
    changeItemAnimation.newItem = newContent 
    changeItemAnimation.running = true
  }
  
  function setContent(newContent: Item, anchorItem: Item) {
    root.isReplacing = false
    if(newContent === root.content) return
    if(root.content) {
      replaceContent(newContent, anchorItem);
      return;
    }
    root.targetX = calculateX(newContent, anchorItem)
    root.targetHeight = Qt.binding(() => newContent.height + 30)
    root.targetWidth = Qt.binding(() => newContent.width + 20)
    openAnimation.content = newContent 
    openAnimation.running = true; 
  }

  function close() {
    closeAnimation.running = true
  }

  Rectangle {
    id: wrapperRect
    width: parent.width
    height: parent.height - 10
    radius: 10
    color: "transparent"
    y: root.targetY

    Behavior on opacity {
      NumberAnimation {
        duration: 25
      }
    }

    Rectangle {
      id: contentWrapper
      anchors.fill: parent
      anchors.margins: 10
      children: root.content ? [root.content] : []
      color: "transparent"
      clip: true
      
    }
  } 
}