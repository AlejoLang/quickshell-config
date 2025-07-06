import QtQuick

Rectangle {
    property real progress: 0.0

    function getProgress() {
        return progress;
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * parent.progress
        color: "#00FF00"
    }
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * (1 - parent.progress)
        color: "#FF0000"
    }

    MouseArea {
        anchors.fill: parent
        onPositionChanged: (event) =>{
            event.accepted = true;
            if (event.buttons === Qt.LeftButton) {
                var newProgress = event.x / parent.width;
                if (newProgress < 0) newProgress = 0;
                if (newProgress > 1) newProgress = 1;
                parent.progress = newProgress;
            }
        }
        onClicked: (event) => {
            event.accepted = true;
            if (event.button === Qt.LeftButton) {
                var newProgress = event.x / parent.width;
                if (newProgress < 0) newProgress = 0;
                if (newProgress > 1) newProgress = 1;
                parent.progress = newProgress;
            }
        }
    }
}