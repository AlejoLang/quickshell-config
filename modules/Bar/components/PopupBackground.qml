import QtQuick
import QtQuick.Shapes

ShapePath {
    id: root
    property Popup popup
    property int round: 20
    property bool flatten: height < round * 2
    property int realR: flatten ? height / 2 : round
    property real height: popup.active ? popup?.popupHeight ?? 0 : 0
    property real width: popup?.popupWidth ?? 0
    strokeColor: "#000"
    strokeWidth: -1
    fillColor: "#EFEFEF"
    onStartXChanged: {
        console.log("Start X changed to: " + startX);
    }
    onStartYChanged: {
        console.log("Start Y changed to: " + startY);
    }
    Behavior on startX {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    Behavior on startY {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    PathArc {
        relativeX: root.round
        relativeY: root.realR 
        radiusX: root.round
        radiusY: root.realR
    }

    PathLine {
        relativeX: 0
        relativeY: root.height - 2*root.realR ?? 0
    }
    PathArc {
        relativeX: root.round
        relativeY: root.realR
        radiusX: root.round
        radiusY: root.realR
        direction: PathArc.Counterclockwise
    }
    PathLine {
        relativeX: root.width - 2*root.round ?? 0
        relativeY: 0
    }
    PathArc {
        relativeX: root.round
        relativeY: -root.realR
        radiusX: -root.round
        radiusY: -root.realR
        direction: PathArc.Counterclockwise
    }
    PathLine {
        relativeX: 0
        relativeY: -root.height + 2*root.realR ?? 0
    }
    PathArc {
        relativeX: root.round
        relativeY: -root.realR
        radiusX: root.round
        radiusY: root.realR
        direction: PathArc.Clockwise
    }

    Behavior on width {
        NumberAnimation {
            duration: 400
            easing.type: Easing.InOutCubic
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: 400
            easing.type: Easing.InOutCubic
        }
    }
}