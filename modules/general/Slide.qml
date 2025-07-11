import QtQuick

Rectangle {
    id: root
    property real percentaje: 0 // 0 to 1
    property real livePercentaje: percentaje // Used for dynamic updates
    property var posAux: null
    property bool dynamic: false // If true, the percentaje will be updated dynamically based on mouse position. If false, the percentaje will change only on mouse release

    function getPercentaje() {
        return percentaje;
    }

    function getLivePercentaje() {
        return livePercentaje;
    }

    function clamp(value, min, max) {
        return Math.max(min, Math.min(max, value));
    }

    Rectangle {
        anchors.fill: parent
        radius: 5
        color: "#b3b3b3"
    }
    Rectangle {
        width: root.dynamic ? ((parent.percentaje ?? 0) * parent.width) : (root.posAux ?? ((root.percentaje ?? 0) * parent.width))
        height: parent.height
        radius: 5
        color: "#252525"
    }    
    MouseArea {
        anchors.fill: parent
        onReleased: (event) => {
            if (event.button === Qt.LeftButton) {
                root.percentaje = root.clamp((root.posAux ?? event.x) / parent.width, 0, 1);
                root.livePercentaje = root.percentaje; // Update live percentage on release
                root.posAux = null;
            }
        }
        onPositionChanged: (event) =>{
            if (event.buttons === Qt.LeftButton) {
                root.posAux = root.clamp(event.x, 0, parent.width); 
                if (root.dynamic) {root.percentaje = root.clamp(root.posAux / parent.width, 0, 1)};
                root.livePercentaje = root.clamp(root.posAux / parent.width, 0, 1);
            }
        }
        onWheel: (event) => {
            root.percentaje += (event.angleDelta.y > 0 ? 0.01 : -0.01);
            if (root.percentaje < 0) root.percentaje = 0;
            if (root.percentaje > 1) root.percentaje = 1;
            root.livePercentaje = root.percentaje; // Update live percentage on wheel event
        }
    }
}