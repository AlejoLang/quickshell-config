const bluetoothIcons = {
    'audio-card': 'audio_video_receiver',
    'audio-headphones': 'headphones',
    'audio-headset': 'headset_mic',
    'camera-photo': 'camera',
    'camera-video': 'videocam',
    computer: 'computer',
    'input-gaming': 'videogame_asset',
    'input-keyboard': 'keyboard',
    'input-mouse': 'mouse',
    'input-tablet': 'tablet',
    modem: 'router',
    'multimedia-player': 'radio',
    'network-wireless': 'android_wifi_4_bar',
    phone: 'mobile',
    printer: 'print',
    scanner: 'adf_scanner',
    unknown: 'question_mark',
    'video-display': 'monitor',
};

const getBluetoothIconForType = (type) => {
    return bluetoothIcons[type] ?? 'question_mark';
};

