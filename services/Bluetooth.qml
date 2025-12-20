pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root;
    property bool powered: false
    property var bluetoothDevices
    property bool connected: false

    function processGetDevices(json: string) {
        if(!json || json.trim() === "") {
            console.warn("No Bluetooth devices found or empty JSON response on busctl.");
            return;
        }
        const res = JSON.parse(json);
        if(!res.data) {
            console.warn("Invalid JSON response structure on busctl:", res);
            return;
        }
        const filteredDevices = []
        const devices = res.data['0'];
        for (const key of Object.keys(devices)) {
            const data = devices[key];
            if(!data || !data['org.bluez.Device1']) {
                continue;
            }
            const device = deviceComponent.createObject(root, {
                name: data['org.bluez.Device1']?.Name.data ?? "",
                address: data['org.bluez.Device1']?.Address.data ?? "",
                type: data['org.bluez.Device1']?.Icon.data ?? "",
                paired: data['org.bluez.Device1']?.Paired.data ?? false,
                bonded: data['org.bluez.Device1']?.Bonded.data ?? false,
                trusted: data['org.bluez.Device1']?.Trusted.data ?? false,
                connected: data['org.bluez.Device1']?.Connected.data ?? false,
                battery: data['org.bluez.Battery1'] ? (data['org.bluez.Battery1']?.Percentage.data ?? -1) : -1
            });
            filteredDevices.push(device);
        }
        root.bluetoothDevices = filteredDevices.reverse();
        if(root.bluetoothDevices.find(d => d.connected)) {
            root.connected = true;
        } else {
            root.connected = false;
        }
    }

    function setBluetoothPoweredStatus(status) {
        if(status === undefined || status === null) {
            console.warn("Invalid status provided to setBluetoothPoweredStatus:", status);
            return;
        }
        switchBluetoothPowerProcess.status = status;
        switchBluetoothPowerProcess.running = true;
        root.powered = status;
    }

    function switchBluetoothPower() {
        if(switchBluetoothPowerProcess.running) {
            console.warn("Switch process is already running, skipping.");
            return;
        }
        switchBluetoothPowerProcess.status = !switchBluetoothPowerProcess.status;
        switchBluetoothPowerProcess.running = true;
    }

    function refreshDevices() {
        if(refreshDevicesProcess.running) {
            console.warn("Refresh process is already running, skipping.");
            return;
        }
        refreshDevicesProcess.running = true;
    }

    function connectToDevice(device) {
        if(connectDeviceProcess.running) {
            console.warn("Connect process is already running, skipping.");
            return;
        }
        connectDeviceProcess.deviceAddress = device.address;
        connectDeviceProcess.running = true;
    }

    function disconnectFromDevice(device) {
        if(disconnectDeviceProcess.running) {
            console.warn("Disconnect process is already running, skipping.");
            return;
        }
        disconnectDeviceProcess.deviceAddress = device.address;
        disconnectDeviceProcess.running = true;
    }

    function pairDevice(device) {
        if(pairDeviceProcess.running) {
            console.warn("Pair process is already running, skipping.");
            return;
        }
        pairDeviceProcess.deviceAddress = device.address;
        pairDeviceProcess.running = true;
    }

    function removeDevice(device) {
        if(removeDeviceProcess.running) {
            console.warn("Remove process is already running, skipping.");
            return;
        }
        removeDeviceProcess.deviceAddress = device.address;
        removeDeviceProcess.running = true;
    }

    function trustDevice(device) {
        if(trustDeviceProcess.running) {
            console.warn("Trust process is already running, skipping.");
            return;
        }
        trustDeviceProcess.deviceAddress = device.address;
        trustDeviceProcess.running = true;
    }

    function untrustDevice(device) {
        if(untrustDeviceProcess.running) {
            console.warn("Untrust process is already running, skipping.");
            return;
        }
        untrustDeviceProcess.deviceAddress = device.address;
        untrustDeviceProcess.running = true;
    }

    Timer {
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            initialBluetoothPoweredStatusProcess.running = true;
            getDevicesProcess.running = true
        }
    } 

    Process {
        id: monitorBluetoothProcess;
        running: true;
        command: ["bluetoothctl", "--monitor"];
        stdout: SplitParser {
            onRead: {
                console.log("Bluetooth monitor output:");
                if(!getDevicesProcess.running) {
                    getDevicesProcess.running = true;
                }
            }
        }
    }

    Process {
        id: initialBluetoothPoweredStatusProcess;
        running: true;
        command: ["bluetoothctl", "show"];
        stdout: StdioCollector {
            onStreamFinished: {
                const textLower = text.toLowerCase();
                if(textLower.includes("powered: yes")) {
                    root.powered = true;
                } else if(textLower.includes("powered: no")) {
                    root.powered = false;
                } else {
                    console.warn("Failed to determine initial Bluetooth power status:", text); 
                }
            }
        }
    }    

    Process {
        id: switchBluetoothPowerProcess;
        property bool status: false; // true for on, false for off
        running: false;
        command: ["bluetoothctl", "power", status ? "on" : "off"];
        stdout: StdioCollector {
            onStreamFinished: {
                if(text.toLowerCase().includes("changing power on succeeded")) {
                    root.powered = true;
                } else if(text.toLowerCase().includes("changing power off succeeded")) {
                    root.powered = false;
                } else {
                    console.warn("Failed to switch Bluetooth power:", text);
                }
            }
        }
    }

    Process {
        id: getDevicesProcess;
        command: ["busctl", "--system", "call", "org.bluez", "/", "org.freedesktop.DBus.ObjectManager", "GetManagedObjects", "-j"];
        stdout: StdioCollector {
            onStreamFinished: root.processGetDevices(text)
        }
    }

    Process {
        id: connectDeviceProcess;
        property string deviceAddress: "";
        running: false;
        command: ["bluetoothctl", "connect", deviceAddress];
        stdout: StdioCollector {
            onStreamFinished: {
                if(text.toLowerCase().includes("connection successful")) {
                    root.connected = true;
                } else {
                    console.warn("Failed to connect to device:", connectDeviceProcess.deviceAddress);
                }
            }
        }
    }

    Process {
        id: disconnectDeviceProcess;
        property string deviceAddress: "";
        running: false;
        command: ["bluetoothctl", "disconnect", deviceAddress];
        stdout: StdioCollector {
            onStreamFinished: {
                if(text.toLowerCase().includes("disconnection successful")) {
                    root.connected = false;
                } else {
                    console.warn("Failed to disconnect from device:", disconnectDeviceProcess.deviceAddress);
                }
            }
        }
    }

    Process {
        id: pairDeviceProcess;
        property string deviceAddress: "";
        running: false;
        command: ["bluetoothctl", "pair", deviceAddress];
    }       

    Process {
        id: removeDeviceProcess;
        property string deviceAddress: "";
        running: false;
        command: ["bluetoothctl", "remove", deviceAddress];
    }

    Process {
        id: trustDeviceProcess;
        property string deviceAddress: "";
        running: false;
        command: ["bluetoothctl", "trust", deviceAddress];
    }

    Process {
        id: untrustDeviceProcess;
        property string deviceAddress: "";
        running: false;
        command: ["bluetoothctl", "untrust", deviceAddress];
    }

    Process {
        id: refreshDevicesProcess;
        running: false;
        command: [ "bluetoothctl", "--timeout", "10", "scan", "on" ];
        stdout: StdioCollector {
            onStreamFinished: {
                getDevicesProcess.running = true;
            }
        }
    }

    component Device: QtObject {
        property string name: ""
        property string address: ""
        property string type: ""
        property bool paired: false
        property bool bonded: false
        property bool trusted: false
        property bool connected: false
        property int battery: 0
    }    
    Component {
        id: deviceComponent
        Device {}
    }
}