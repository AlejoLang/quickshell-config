import QtQuick
import QtQuick.Layouts
import "root:/services/" as Services
import "../../../general"

Rectangle {
    width: 400
    height: Services.Bluetooth.bluetoothDevices.length * 50 + 150
    color: "transparent"
    radius: 5

    ColumnLayout {
        width: parent.width - 20
        height: parent.height - 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: childrenRect.height
            Layout.topMargin: 10

            Text {
                text: "Bluetooth"
                font.family: "CaskaydiaCove Nerd Font"
                font.pixelSize: 24
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
            }
            DefaultCheck {
                Layout.preferredHeight: 24
                Layout.preferredWidth: 40
                checked: Services.Bluetooth.powered
                onCheckedChanged: {
                    Services.Bluetooth.setBluetoothPoweredStatus(checked);
                }
            }
        } 

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 2
            color: "#252525"
        }

        ColumnLayout {
            spacing: 5
            Layout.fillWidth: true
            Layout.preferredHeight: childrenRect.height + 20
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                Layout.bottomMargin: 5
                Text {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.fillWidth: true
                    text: "Devices"
                    font.pixelSize: 18
                    font.family: "CaskaydiaCove Nerd Font"
                    font.bold: true
                }
                DefaultButton {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    text: "Refresh"
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 32
                    onClicked: {
                        Services.Bluetooth.refreshDevices();
                    }
                }
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: Services.Bluetooth.bluetoothDevices.length * 50 + 10
                Layout.alignment: Qt.AlignVCenter
                Repeater {
                    model: Services.Bluetooth.bluetoothDevices
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        color: "#d3d3d3"
                        border.color: "#d0d0d0"
                        border.width: 1
                        radius: 5
                        RowLayout {
                            spacing: 5
                            width: parent.width - 20
                            height: parent.height
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                text: modelData.name || "Unknown Device"
                                font.pixelSize: 16
                                font.family: "CaskaydiaCove Nerd Font"
                                color: "#252525"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                Layout.fillWidth: true
                            }
                            RowLayout {
                                Layout.preferredWidth: childrenRect.width
                                Layout.preferredHeight: 24
                                DefaultButton {
                                    text: "plug_connect"
                                    font.bold: modelData.connected
                                    text_color: "#252525"
                                    background_color: "transparent"
                                    onClicked: {
                                        if (modelData.connected) {
                                            Services.Bluetooth.disconnectFromDevice(modelData);
                                        } else {
                                            Services.Bluetooth.connectToDevice(modelData);
                                        }
                                    }
                                }
                                DefaultButton {
                                    text: "delete"
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    text_color: "#252525"
                                    background_color: "transparent"
                                    onClicked: {
                                        Services.Bluetooth.removeDevice(modelData);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } 
    } 
}
