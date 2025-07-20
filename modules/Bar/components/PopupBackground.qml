import QtQuick
import QtQuick.Shapes

ShapePath {
    id: root
    property Popup popup
    property int round: 10
    strokeColor: "#000"
    strokeWidth: -1
    fillColor: "#EFEFEF"
    onStartXChanged: {
        console.log("Start X changed to: " + startX);
    }
    onStartYChanged: {
        console.log("Start Y changed to: " + startY);
    }

    PathArc {
        relativeX: root.round
        relativeY: root.round
        radiusX: root.round
        radiusY: root.round
        direction: PathArc.Clockwise
    }

    PathLine {
        relativeX: 0
        relativeY: root.popup.popupHeight - 2*root.round
    }
    PathArc {
        relativeX: root.round
        relativeY: root.round
        radiusX: root.round
        radiusY: root.round
        direction: PathArc.Counterclockwise
    }
    PathLine {
        relativeX: root.popup.content.width - 2*root.round
        relativeY: 0
    }
    PathArc {
        relativeX: root.round
        relativeY: -root.round
        radiusX: root.round
        radiusY: root.round
        direction: PathArc.Counterclockwise
    }
    PathLine {
        relativeX: 0
        relativeY: -root.popup.popupHeight + 2*root.round
    }
    PathArc {
        relativeX: root.round
        relativeY: -root.round
        radiusX: root.round
        radiusY: root.round
        direction: PathArc.Clockwise
    }
}