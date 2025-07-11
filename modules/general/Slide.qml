import QtQuick

Rectangle {
    id: root
    property real percentage: 0 // 0 to 1
    property real livePercentage: percentage // Used for dynamic updates
    property var posAux: null
    property bool dynamic: false // If true, the percentage will be updated dynamically based on mouse position. If false, the percentage will change only on mouse release

    function getPercentage() {
        return percentage;
    }

    function getLivePercentage() {
        return livePercentage;
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
        width: root.dynamic ? ((parent.percentage ?? 0) * parent.width) : (root.posAux ?? ((root.percentage ?? 0) * parent.width))
        height: parent.height
        radius: 5
        color: "#252525"
    }    
    MouseArea {
        anchors.fill: parent
        onReleased: (event) => {
            if (event.button === Qt.LeftButton) {
                root.percentage = root.clamp((root.posAux ?? event.x) / parent.width, 0, 1);
                root.livePercentage = root.percentage; // Update live percentage on release
                root.posAux = null;
            }
        }
        onPositionChanged: (event) =>{
            if (event.buttons === Qt.LeftButton) {
                root.posAux = root.clamp(event.x, 0, parent.width); 
                if (root.dynamic) {root.percentage = root.clamp(root.posAux / parent.width, 0, 1)};
                root.livePercentage = root.clamp(root.posAux / parent.width, 0, 1);
            }
        }
        onWheel: (event) => {
            root.percentage += (event.angleDelta.y > 0 ? 0.01 : -0.01);
            if (root.percentage < 0) root.percentage = 0;
            if (root.percentage > 1) root.percentage = 1;
            root.livePercentage = root.percentage; // Update live percentage on wheel event
        }
    }
}