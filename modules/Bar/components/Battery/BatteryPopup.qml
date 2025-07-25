import QtQuick
import QtQuick.Layouts
import "root:/services/" as Services
import "../../../general/"
import Quickshell.Services.UPower

Rectangle {
    id: root
    implicitWidth: 400
    implicitHeight: batteryPopupColumn.height
    color: "#EFEFEF"
    bottomLeftRadius: 10
    bottomRightRadius: 10

    ColumnLayout {
        id: batteryPopupColumn
        width: parent.width
        anchors.centerIn: parent
        spacing: 5
        Text {
            id: batteryPopupStatus
            text: "Status: " + Services.Battery.getBatteryState()
            font.bold: true
            font.pixelSize: 16
            font.family: "CaskaydiaCove Nerd Font"
            color: "#252525"
        }
        Text {
            id: batteryPopupRate
            text: "Rate: " + Math.abs(Services.Battery.getBatteryRate()) + " W"
            font.pixelSize: 16
            font.family: "CaskaydiaCove Nerd Font"
            color: "#252525"
        }
        Text {
            id: batteryPopupTime
            font.pixelSize: 16
            visible: Services.Battery.battery.state === UPowerDeviceState.Charging || 
                     Services.Battery.battery.state === UPowerDeviceState.Discharging
            text: {
                const timeInSeconds = Services.Battery.getTime();
                const hours = Math.floor(timeInSeconds / 3600);
                const minutes = Math.floor((timeInSeconds % 3600) / 60);
                switch (Services.Battery.battery.state) {
                    case UPowerDeviceState.Charging:
                        return `Time to full: ${hours}h ${minutes}m`;
                    case UPowerDeviceState.Discharging:
                        return `Time to empty: ${hours}h ${minutes}m`;
                    case UPowerDeviceState.FullyCharged:
                        return 'Full';
                    default:
                        return '';
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
            Text {
                text: "Hyprsunset"
                font.pixelSize: 18
                font.bold: true
                font.family: "CaskaydiaCove Nerd Font"
            } 
            RowLayout {
                spacing: 5
                Layout.fillWidth: true
                Text {
                    text: "Enabled"
                    font.pixelSize: 16
                    font.family: "CaskaydiaCove Nerd Font"
                    color: "#252525"
                }
                DefaultCheck {
                    id: hyprsunsetSwitch
                    Layout.preferredWidth: 35
                    Layout.preferredHeight: 20
                    onCheckedChanged: {
                        if (hyprsunsetSwitch.checked) {
                            Services.Hyprland.dispatch(`exec hyprctl hyprsunset temperature ${Math.round(hyprsunsetSlider.value)}`);
                        } else {
                            Services.Hyprland.dispatch(`exec hyprctl hyprsunset temperature 6000`);
                        }
                    } 
                }
            }
            RowLayout {
                spacing: 5
                Layout.fillWidth: true
                DefaultSlide {
                    id: hyprsunsetSlider
                    Layout.fillWidth: true
                    Layout.preferredHeight: 10
                    from: 1000
                    to: 16000
                    stepSize: 10
                    value: 6000
                    live: false
                    onValueChanged: {
                        if (hyprsunsetSwitch.checked) {
                            Services.Hyprland.dispatch(`exec hyprctl hyprsunset temperature ${Math.round(hyprsunsetSlider.value)}`);
                        }
                    }
                }
                Text {
                    Layout.preferredWidth: 50
                    Layout.rightMargin: 5
                    text: Math.round((hyprsunsetSlider.visualPosition.toFixed(5) * 15000) + 1000) + "K"
                    font.pixelSize: 16
                    font.family: "CaskaydiaCove Nerd Font"
                    color: "#252525"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
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
            Text {
                text: "Displays brightness"
                font.pixelSize: 18
                font.family: "CaskaydiaCove Nerd Font"
                font.bold: true
            }
            Repeater {
                model: Services.Display.displays
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    color: "#f0f0f0"
                    border.color: "#d0d0d0"
                    border.width: 1
                    radius: 5
                    ColumnLayout {
                        spacing: 5
                        width: parent.width - 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text: modelData.name
                            font.pixelSize: 16
                            font.family: "CaskaydiaCove Nerd Font"
                            color: "#252525"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            DefaultSlide {
                                id: brightnessSlider
                                Layout.fillWidth: true
                                Layout.preferredHeight: 10
                                from: 0
                                to: 1
                                stepSize: 0.01
                                value: (modelData.currentBrightness / modelData.maxBrightness)
                                onValueChanged: {
                                    Services.Display.setBrightness(modelData, brightnessSlider.value);
                                }
                            }
                            Text {
                                Layout.preferredWidth: 50
                                Layout.rightMargin: 5
                                text: Math.round(brightnessSlider.value * 100) + "%"
                                font.pixelSize: 16
                                font.family: "CaskaydiaCove Nerd Font"
                                color: "#252525"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                       
                    }
                }
            }
        }
    }
}