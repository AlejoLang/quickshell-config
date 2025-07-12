import QtQuick
import QtQuick.Controls

CheckBox {
    id: root
    checked: false
    onCheckedChanged: {
        if (root.checked) {
            root.indicator.x = root.width - root.indicator.width - 3;
        } else {
            root.indicator.x = 3
        }
    }

    indicator: Rectangle {
        width: root.height - 5
        height: root.height - 5
        x: 3
        y: root.height / 2 - (root.height - 5) / 2
        radius: (root.height - 5) / 2
        color: "white"
    }

    background: Rectangle {
        color: root.checked ? "#237dc7" : "#c9c9c9"
        radius: parent.height / 2
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
    }
}