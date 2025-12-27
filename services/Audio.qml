// Using the integrated Pipewire service to manage audio sources and sinks in Quickshell.
// For audio control im using wpctl (Wireplumber)
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Pipewire
import '../utils/audioIcons.js' as AudioIcons

Singleton {
    id: root
    property list<PwNode> sinksList: Pipewire.nodes.values.filter(node => (!node.isStream && node.isSink && node.audio));
    property list<PwNode> sourcesList: Pipewire.nodes.values.filter(node => (!node.isStream && !node.isSink && node.audio));
    property PwNode currentSource: Pipewire.defaultAudioSource ?? null;
    property string currentSourceIcon: 'mic';
    property PwNode currentSink: Pipewire.defaultAudioSink ?? null;
    property string currentSinkIcon: 'speaker';

    function setup () {
        getSourceIconProcess.nodeId = root.currentSource ? root.currentSource.id : 0;
        getSourceIconProcess.running = true;
        getSinkIconProcess.nodeId = root.currentSink ? root.currentSink.id : 0;
        getSinkIconProcess.running = true;
    }

    function setNodeVolume(nodeId: int, volume: real) {
        let node = tracker.objects.find(n => n.id === nodeId);
        if(!node) {
            console.warn("Node with ID", nodeId, "not found in tracker.");
            return;
        }
        node.audio.volume = Math.max(0, Math.min(1, volume));
    }

    function toggleNodeMute(nodeId: int) {
        let node = tracker.objects.find(n => n.id === nodeId);
        if(!node) {
            console.warn("Node with ID", nodeId, "not found in tracker.");
            return;
        }
        node.audio.muted = !node.audio.muted;
    }

    function switchDefaultNode(nodeId: int) {
        if(switchDefaultNodeProcess.running) {
            console.warn("Node switch process already running");
        }
        let node = tracker.objects.find(n => n.id === nodeId);
        if(!node) {
            console.warn("Node not found");
        }
        switchDefaultNodeProcess.nodeId = nodeId; 
        switchDefaultNodeProcess.running = true;
    }

    function getCurrentSourceIcon() {
        return AudioIcons.getAudioIconName(root.currentSourceIcon ?? '', 'Audio/Source');
    }
    
    function getCurrentSinkIcon() {
        return AudioIcons.getAudioIconName(root.currentSinkIcon ?? '', 'Audio/Sink');
    }

    function getCurrentSinkVolumePerc() {
        return root.currentSink ? (root.currentSink.audio.volume * 100).toFixed(0) : 0;
    }

    function getCurrentNodeIcon(nodeId: int): string {
        let node = tracker.objects.find(n => n.id === nodeId);
        if(!node) {
            console.warn("Node not found");
        }
        if(nodeId == root.currentSink.id) {
            return root.getCurrentSinkIcon()
        } else if (nodeId == root.currentSource.id) {
            return root.getCurrentSourceIcon()
        }
        if(node.isSink) {
            return 'speaker';
        } else {
            return 'mic';
        }
    }
    
    function getNodeVolumeIcon(nodeId: int): string {
        let node = tracker.objects.find(n => n.id === nodeId);
        if(!node) {
            console.warn("Node not found")
        }
        const volume = node?.audio?.muted ? -1 : (node?.audio?.volume * 100 ?? -1)
        return AudioIcons.getVolumeIcon(volume, node?.isSink)
    }

    function increaseCurrentSinkVolume(delta: real) {
        if (root.currentSink) {
            let newVolume = root.currentSink.audio.volume + delta;
            root.setNodeVolume(root.currentSink.id, newVolume);
        }
    }

    Timer {
        interval: 1
        repeat: false
        running: true
        onTriggered: root.setup()
    }

    Timer {
        interval: 1000 // Refresh every second
        repeat: true
        running: true
        onTriggered: root.setup()
    }

    Process {
        id: switchDefaultNodeProcess
        property int nodeId: 0 // Default to first sink
        command: ["wpctl", "set-default", nodeId]
        running: false
    } 
    Process {
        id: getSourceIconProcess
        property int nodeId: 0 // Default to first node
        command: ["wpctl", "inspect", nodeId, "-r"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const iconLineStart = text.indexOf("device.icon-name");
                const iconLineEnd = text.indexOf("\n", iconLineStart);
                if (iconLineStart !== -1 && iconLineEnd !== -1) {
                    const iconName = text.substring(iconLineStart, iconLineEnd).split('=')[1].trim().replace(/"/g, '');
                    root.currentSourceIcon = iconName; 
                }
            }
        }
    }
    Process {
        id: getSinkIconProcess
        property int nodeId: 0 // Default to first node
        command: ["wpctl", "inspect", nodeId, "-r"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const iconLineStart = text.indexOf("device.icon-name");
                const iconLineEnd = text.indexOf("\n", iconLineStart);
                if (iconLineStart !== -1 && iconLineEnd !== -1) {
                    const iconName = text.substring(iconLineStart, iconLineEnd).split('=')[1].trim().replace(/"/g, '');
                    root.currentSinkIcon = iconName; 
                }
            }
        }
    }
    
    PwObjectTracker {
        id: tracker
        objects: [...root.sinksList, ...root.sourcesList]
    }
}