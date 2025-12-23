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
  
  implicitHeight: root?.content ? root.content.height + 20 : 1
  implicitWidth:  1
  anchor.window: window
  anchor.rect.x: 0
  anchor.rect.y: root.bar.height ?? 0
  color: "transparent"

  ParallelAnimation {
    id: openAnimation
    property Item content 
    PropertyAnimation {
      target: root
      property: "anchor.rect.y"
      to: root.bar.height + 10
      duration: 100
    }
    PropertyAnimation {
      target: root
      property: "implicitHeight"
      to: openAnimation.content.height + 20
      duration: 100
    }
    onStarted: {
      console.log(openAnimation.content.height)
      root.visible = true
      root.opening_closing = true
    }
    onFinished: {
      root.content = openAnimation.content
      root.content.visible = true
      root.opening_closing = false
    }
  }

  ParallelAnimation {
    id: closeAnimation
    PropertyAnimation {
      target: root
      property: "anchor.rect.y"
      to: root.bar.height
      duration: 100
    }
    PropertyAnimation {
      target: root
      property: "implicitHeight"
      to: 1
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
      property: "height"
      to: changeItemAnimation.newItem.height + 20
      duration: 200
    }
    PropertyAnimation {
      target: root
      property: "width"
      to: changeItemAnimation.newItem.width + 20
      duration: 200
    }
    PropertyAnimation {
      target:root
      property: "anchor.rect.x"
      to: changeItemAnimation.newX
      duration: 200
    }
    onFinished: {
      root.content = newItem
      root.content.visible = true
      root.isReplacing = false
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
    
    root.anchor.rect.x = calculateX(newContent, anchorItem)
    root.implicitWidth = newContent.width + 20
    wrapperRect.opacity = 1
    openAnimation.content = newContent 
    openAnimation.running = true; 
  }

  function close() {
    wrapperRect.opacity = 0
    closeAnimation.running = true
  }
  
  Rectangle {
    id: wrapperRect
    anchors.fill: parent
    radius: 10
    color: "transparent"
    clip: true

    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }
     
    Rectangle {
      color: "transparent"
      id: contentWrapper
      implicitWidth: root.content ? root.content.width : 0
      implicitHeight: root.content ? root.content.height : 0
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.topMargin: 10
      children: root.content ? [root.content] : []
    }
  } 
}