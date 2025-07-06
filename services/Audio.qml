// Using the integrated Pipewire service to manage audio sources and sinks in Quickshell.
// For audio control im using wpctl (Wireplumber)
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Pipewire

Singleton {
    id: root
    property list<PwNode> sinksList: [];
    property list<PwNode> sourcesList: [];
    property PwNode currentSource: Pipewire.defaultAudioSource ?? null;
    property PwNode currentSink: Pipewire.defaultAudioSink ?? null;

    function setup () {
        const sinks = Pipewire.nodes.values.filter(node => (!node.isStream && node.isSink && node.audio));
        const sources = Pipewire.nodes.values.filter(node => (!node.isStream && !node.isSink && node.audio));
        root.sinksList = sinks 
        root.sourcesList = sources
        const aux = [...sinks, ...sources];
        for (const node of aux) {
            if(!tracker.objects.find(n => n.id === node.id)) {
                tracker.objects.push(node);
            }
        }
    }

    function setNodeVolume(nodeId: int, volume: real) {
        let node = tracker.objects.find(n => n.id === nodeId);
        if(!node) {
            console.warn("Node with ID", nodeId, "not found in tracker.");
            return;
        }
        if(volume < 0) {
            node.audio.volume = 0.00; // Clamp volume to [0, 1]
            return;
        }
        if(volume > 1) {
            node.audio.volume = 1.00; // Clamp volume to [0, 1]
            return;
        }
        node.audio.volume = volume
    }

    function toggleNodeMute(nodeId: int) {
        let node = tracker.objects.find(n => n.id === nodeId);
        if(!node) {
            console.warn("Node with ID", nodeId, "not found in tracker.");
            return;
        }
        node.audio.muted = !node.audio.muted;
    }

    function switchAudioSink(nodeId: int) {
        if(switchAudioSinkProcess.running) {
            console.warn("Switch process is already running, skipping.");
            return;
        }
        switchAudioSinkProcess.nodeId = nodeId;
        switchAudioSinkProcess.running = true;
    }

    function switchAudioSource(nodeId: int) {
        if(switchAudioSourceProcess.running) {
            console.warn("Switch process is already running, skipping.");
            return;
        }
        switchAudioSourceProcess.nodeId = nodeId;
        switchAudioSourceProcess.running = true;
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
        id: switchAudioSinkProcess
        property int nodeId: 0 // Default to first sink
        command: ["wpctl", "set-default", "node", nodeId]
        running: false
    } 
    Process {
        id: switchAudioSourceProcess
        property int nodeId: 0 // Default to first source
        command: ["wpctl", "set-default", "source", nodeId]
        running: false
    }

    PwObjectTracker {
        id: tracker
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
}