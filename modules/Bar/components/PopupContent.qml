import Quickshell
import QtQuick

Item {
    id: root
    property var window
    property Item owner
    property real posX
    property real posY

    readonly property alias contentItem: contentItem;
	default property alias data: contentItem.data;

    Item {
        id: contentItem
        anchors.fill: parent

        implicitHeight: childrenRect.height
        implicitWidth: childrenRect.width

    }
}