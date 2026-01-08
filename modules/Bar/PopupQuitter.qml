pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

MouseArea {
  id: root
  property Popup popup
  property Item bar
  property PanelWindow window
  property ShellScreen screen

  anchors.fill: parent
  anchors.topMargin: bar.height
  
  visible: popup !== null && popup.visible
  enabled: visible
  
  onPressed: (mouse) => {
    mouse.accepted = true
  }
  
  onClicked: (mouse) => {
    if (!root.popup || !root.popup.visible) return
    
    let popupX = root.popup.anchor?.rect?.x ?? 0
    let popupY = (root.popup.anchor?.rect?.y ?? 0)
    let popupW = root.popup.width ?? 0
    let popupH = root.popup.height ?? 0
    
    if (mouse.x < popupX || mouse.x > popupX + popupW ||
        mouse.y < popupY || mouse.y > popupY + popupH) {
      root.popup.close()
    }
  }
}
