const audioClassIcons = {
    'audio-headset': 'headset_mic',
    'audio-headset-bluetooth': 'headset_mic',
    headset: 'headphones_mic',
    'headset-bluetooth': 'headphones_mic',
    'audio-headphones': 'headphones',
    'audio-headphones-bluetooth': 'headphones',
    headphones: 'headphones',
    'headphones-bluetooth': 'headphones',
    'audio-speakers': 'speaker',
    speakers: 'speaker',
    'audio-input-microphone': 'mic',
    microphone: 'mic',
};

function getAudioIconName(className, typeName) {
    if (typeName === 'Audio/Sink') {
        if (className.includes('audio-card')) {
            return audioClassIcons.speakers;
        }
        return audioClassIcons[className] || audioClassIcons.speakers;
    }
    if (typeName === 'Audio/Source') {
        if (className.includes('audio-card')) {
            return audioClassIcons.microphone;
        }
        return audioClassIcons[className] || audioClassIcons.microphone;
    }
    return 'graphic_eq';
}

