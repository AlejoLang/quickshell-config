pragma Singleton
import Quickshell.Services.UPower
import Quickshell
import "../utils/batteryIcons.js" as BatteryIcons


Singleton {
    id: root
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

    function getTime () {
        if (root.battery.state === UPowerDeviceState.Charging) {
            return root.getTimeToFull()
        } else if (root.battery.state === UPowerDeviceState.Discharging) {
            return root.getTimeToEmpty()
        }
        return 0;
    }

    function getBatteryRate() {
        if (battery) {
            const rate = battery.changeRate || 0;
            return rate.toFixed(2)
        }
        return 0
    }
}