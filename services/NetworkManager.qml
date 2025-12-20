pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "../utils/networkIcons.js" as NetworkIcons

Singleton {
    id: root
    property bool active: false
    property var networksList
    property Network activeNetwork: null
    property int connectionStrength: 0
    property string connectionIcon: ""

    function updateNetworkList(output: string) {
        const networks = output.trim().split("\n").map(line => {
            const parts = line.split(":");
            if (parts.length < 4) return null; // Invalid line
            return networkComponent.createObject(root, {
                name: parts[0],
                strength: parseInt(parts[2]),
                connected: (parts[3] === "yes" || parts[3] === "sí" || parts[3] === "si" ),
            });
        }).filter(n => n !== null);
        root.networksList = networks;
    }

    function updateActiveNetwork() {
        activeNetwork = root.networksList?.find(n => n.connected) || null;
    }

    function update() {
        networksListProcess.running = true;
        wifiStatusInitProcess.running = true;
        updateActiveNetwork();
    }

    function switchWifiPower() {
        switchWifiPowerProcess.status = !switchWifiPowerProcess.status;
        switchWifiPowerProcess.running = true;
        root.active = switchWifiPowerProcess.status;
    }

    function connectToNetwork(network: var, password: string) {
        if(network === null) {
            console.warn("Network is null, cannot connect.");
            return;
        }
        disconnectFormNetwork()
        if (network.connected) {
            return;
        } else {
            networkConnectProcess.networkName = network.name;
            networkConnectProcess.running = true;
            networkConnectProcess.write(password);
            activeNetwork = network;
        }
    }

    function disconnectFormNetwork() {
        if(root.activeNetwork) {
            networkDisconnectProcess.networkName = root.activeNetwork.name;
            networkDisconnectProcess.running = true;
            root.activeNetwork = null;
        } else {
            console.warn("No active network to disconnect from.");
        }
    }

    function getNetworkStrenghtIcon(network: Network): string {
        return NetworkIcons.getIconForStrength(network?.strength ?? -1)
    }

    function getActiveNetworkStrenghtIcon(): string {
        return getNetworkStrenghtIcon(root?.activeNetwork ?? null);
    }

    Timer {
        interval: 1
        repeat: false
        running: true
        onTriggered: root.update()
    }

    Timer {
        interval: 5000 // Refresh every 5 second
        repeat: true
        running: true
        onTriggered: root.update()
    }

    Process {
        id: networksListProcess
        command: ["nmcli", "-t", "-f", "SSID,SECURITY,SIGNAL,ACTIVE", "device", "wifi"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: () => {
                root.updateNetworkList(text);
            }
        }
    }

    Process {
        id: switchWifiPowerProcess
        property bool status: wifiStatusInitProcess.initialStatus;
        command: ["nmcli", "radio", "wifi", status ? "on" : "off"]
        running: false
    }

    Process {
        id: wifiStatusInitProcess
        property bool initialStatus: false;
        command: ["nmcli", "-t", "-f", "wifi", "radio"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: () => {
                wifiStatusInitProcess.initialStatus = (text.trim() === "enabled");
                root.active = wifiStatusInitProcess.initialStatus;
            }
        }
    }

    Process {
        id: networkConnectProcess
        property string networkName: "";
        property string password: "";
        command: ["nmcli", "device", "wifi", "connect", networkName, "--ask"];
        stdinEnabled: true
        running: false
    }

    Process {
        id: networkDisconnectProcess
        property string networkName: "";
        command: ["nmcli", "device", "disconnect", networkName];
        running: false
    }

    component Network: QtObject {
        property string name: ""
        property int strength: 0
        property bool connected: false
        property bool wired: false
    }
    Component {
        id: networkComponent
        Network {}
    }
}