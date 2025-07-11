import QtQuick
import Quickshell
import "../Bar/components"

MouseArea {
    id: root
    property ShellScreen screen
    property PanelWindow window
    property Popup barPopup
    
    width: screen.width
    height: screen.height
    anchors.fill: parent

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    propagateComposedEvents: true

    function contains(item, point) {
        if (item.x <= point.x && point.x <= item.x + item.width &&
            item.y <= point.y && point.y <= item.y + item.height) {
            return true;
        }
        return false;
    }

    onPositionChanged: (event) => {
        if (barPopup && barPopup.visible) {
            const relative = window.itemPosition(barPopup.content.owner);
            const relativeRect = Qt.rect(relative.x, relative.y, barPopup.content.owner.width, barPopup.content.owner.height);
            if (barPopup.contains(event) || root.contains(relativeRect, event)) {
                // If the mouse is over the popup or its content, do not close it
            } else {
                // If the mouse is outside the popup and its content, hide the popup
                barPopup.visible = false;
            }
        }
        event.accepted = true;
    }
}