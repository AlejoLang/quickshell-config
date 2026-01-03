const networkIcons = {
    0: 'signal_wifi_bad',
    1: 'signal_wifi_0_bar',
    25: 'network_wifi_1_bar',
    50: 'network_wifi_2_bar',
    75: 'network_wifi_3_bar',
    100: 'signal_wifi_4_bar',
};

const getIconForStrength = (strength) => {
    if (strength < 0 || strength > 100) {
        return 'signal_wifi_bad';
    }
    const keys = Object.keys(networkIcons).map(Number);
    for (let i = 0; i < keys.length; i++) {
        if (strength <= keys[i]) {
            return networkIcons[keys[i]];
        }
    }
    return 'signal_wifi_4_bar'; // Default to the strongest signal icon
};

const getIconForEthernet = (status) => {
    if (status == 100 || status == 70) {
        return 'router';
    }
    return 'router_off';
};

const getOffIcon = () => {
    return 'signal_wifi_off';
};

