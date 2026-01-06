pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Slider {
  id: root
  property bool animating: true
  property int type
  property color colorActive: "#32acac"
  property color colorInactive: "#575757"

  enum Type {
    Thin,
    Bold
  }

  property int amplitude: root.pressed || !root.animating ? 0 : 3
  property int wavelenght: 40
  property real period: (2 * Math.PI) / wavelenght
  property real waveStartX: 0
  property int strokeSize: type == MaterialIndicator.Type.Thin ? 4 : 8
  property int indicatorHeight: type == MaterialIndicator.Type.Thin ? 24 : 28
  property int indicatorWidth: 4

  property int nodesNum:  Math.floor(root.width / (root.wavelenght / 2)) + 1

  height: root.indicatorHeight

  Behavior on amplitude {
    NumberAnimation {
      duration: 100
    }
  }

  FrameAnimation {
    running: root.animating && root.visible
    onTriggered: {
      root.waveStartX -= 0.05
      if (root.waveStartX >= 2 * Math.PI) {
        root.waveStartX = 0
      }
    }
  }

  background: Rectangle {
    width: parent.width
    height: parent.height
    color: "transparent"
    Rectangle {
      id: activeSection
      width: (parent.width * root.visualPosition) - (root.indicatorWidth / 2)
      height: parent.height
      color: "transparent"
      Canvas {
        id: waveCanvas
        anchors.fill: parent
        
        onPaint: {
          let ctx = getContext("2d")
          ctx.clearRect(0, 0, width, height)
          
          ctx.beginPath()
          ctx.strokeStyle = root.colorActive
          ctx.lineWidth = root.strokeSize
          
          let centerY = height / 2
          
          for (let x = 0; x <= width; x++) {
            let y = centerY + root.amplitude * Math.sin((root.period * x) - root.waveStartX)
            
            if (x === 0) {
              ctx.moveTo(x, y)
            } else {
              ctx.lineTo(x, y)
            }
          }
          
          ctx.stroke()
        }
        
        Connections {
          target: root
          function onWaveStartXChanged() {
            waveCanvas.requestPaint()
          }
          function onPressedChanged() {
            waveCanvas.requestPaint()
          }
          function onAnimatingChanged() {
            waveCanvas.requestPaint()
          }
        }
      }
    } 
    Rectangle {
      id: inactivePosition
      width: parent.width * (1-root.visualPosition)
      height: root.strokeSize
      x: (parent.width * root.visualPosition) + (root.indicatorWidth / 2)
      y: (parent.height / 2) - (root.strokeSize / 2)
      topRightRadius:  root.strokeSize
      bottomRightRadius:  root.strokeSize
      color: root.colorInactive
    }
  }
  handle: Rectangle {
    height: root.indicatorHeight
    width: root.indicatorWidth
    x: (root.width * root.visualPosition) - (root.indicatorWidth / 2)
    y: (parent.height / 2) - (root.indicatorHeight / 2)
    color: root.colorActive
    radius: root.indicatorWidth
  }
}