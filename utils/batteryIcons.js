const batteryIconsNames = {
    'ac-adapter-symbolic': 'ev_station',
    'battery-full-symbolic': 'battery_full',
    'battery-full-charged-symbolic': 'battery_full',
    'battery-full-charging-symbolic': 'battery_full',
    'battery-critical-symbolic': 'battery_alert',
    'battery-missing-symbolic': 'battery_unknown',
};

const batteryIconsLevelDisconnected = {
    0: 'battery_0_bar',
    20: 'battery_1_bar',
    30: 'battery_2_bar',
    50: 'battery_3_bar',
    60: 'battery_4_bar',
    80: 'battery_5_bar',
    90: 'battery_6_bar',
};

const batteryIconsLevelConnected = {
    0: 'battery_charging_full',
    20: 'battery_charging_20',
    30: 'battery_charging_30',
    50: 'battery_charging_50',
    60: 'battery_charging_60',
    80: 'battery_charging_80',
    90: 'battery_charging_90',
};

const getIcon = (batteryStatus, batteryLevel, icon_name) => {
    switch (batteryStatus) {
        case 'Fully Charged':
            return batteryIconsNames[icon_name];
        case 'Discharging':
            if (batteryLevel === 0) {
                return batteryIconsLevelDisconnected[0];
            } else if (batteryLevel <= 20) {
                return batteryIconsLevelDisconnected[20];
            } else if (batteryLevel <= 30) {
                return batteryIconsLevelDisconnected[30];
            } else if (batteryLevel <= 50) {
                return batteryIconsLevelDisconnected[50];
            } else if (batteryLevel <= 60) {
                return batteryIconsLevelDisconnected[60];
            } else if (batteryLevel <= 80) {
                return batteryIconsLevelDisconnected[80];
            } else if (batteryLevel <= 90) {
                return batteryIconsLevelDisconnected[90];
            } else {
                return batteryIconsNames[icon_name] || 'battery_full';
            }
        case 'Charging':
            if (batteryLevel === 0) {
                return batteryIconsLevelConnected[0];
            } else if (batteryLevel <= 20) {
                return batteryIconsLevelConnected[20];
            } else if (batteryLevel <= 30) {
                return batteryIconsLevelConnected[30];
            } else if (batteryLevel <= 50) {
                return batteryIconsLevelConnected[50];
            } else if (batteryLevel <= 60) {
                return batteryIconsLevelConnected[60];
            } else if (batteryLevel <= 80) {
                return batteryIconsLevelConnected[80];
            } else if (batteryLevel <= 99) {
                return batteryIconsLevelConnected[90];
            } else {
                return batteryIconsNames[icon_name] || 'battery_charging_full';
            }
        default:
            return batteryIconsNames[icon_name] || 'battery_unknown';
    }
};

