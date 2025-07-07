pragma Singleton
import Quickshell.Services.UPower
import Quickshell
import "root:/utils/batteryIcons.js" as BatteryIcons


Singleton {
    property UPowerDevice battery: UPower.devices.values[0] || null

    function getBatteryPercentage() {
        if (battery) {
            return (battery.percentage.toFixed(2) * 100) || 100;
        }
        return 100;
    }

    function getBatteryState() {
        if (battery) {
            return UPowerDeviceState.toString(battery.state);
        }
        return "Unknown";
    }

    function onBattery() {
        return getBatteryState() === "Discharging";
    }

    function getBatteryIcon() {
        if (battery) {
            return BatteryIcons.getIcon(UPowerDeviceState.toString(battery.state), getBatteryPercentage(), battery.iconName);
        }
        return "battery_unknown";
    }

    function getTimeToFull() {
        if (battery) {
            return battery.timeToFull || 0;
        }
        return 0;
    }

    function getTimeToEmpty() {
        if (battery) {
            return battery.timeToEmpty || 0;
        }
        return 0;
    }
}