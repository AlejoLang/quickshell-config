import QtQuick

Rectangle {
    property real progress

    function getProgress() {
        return progress;
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * (parent.progress || 0)
        color: "#EFEFEF"
    }
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * (1 - (parent.progress || 0))
        color: "#131313"
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