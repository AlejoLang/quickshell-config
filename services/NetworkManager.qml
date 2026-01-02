pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "../utils/networkIcons.js" as NetworkIcons

Singleton {
    id: root
    property string wifiInterfaceName
    property string ethernetInterfaceName
    property bool wifiActive: false
    property list<WifiNetwork> wifiNetworksList
    property WifiNetwork activeWifiNetwork: root.wifiNetworksList?.find(n => n.connected) ?? null;
    property WiredNetwork ethernet: null

    function processEthernetData(ethernetData: string) {
        /* Recieves 
            GENERAL.DEVICE: xxxx
            GENERAL.TYPE:ethernet
            GENERAL.HWADDR:xx:xx:xx:xx:xx:xx
            GENERAL.MTU:0000
            GENERAL.STATE: 100 (connected) or 70 (getting ip) or 20 (unaviable)
            GENERAL.CONNECTION: Connection name
            GENERAL.CON-PATH:/org/freedesktop/NetworkManager/ActiveConnection/0
            WIRED-PROPERTIES.CARRIER:on
            IP4.ADDRESS[1]:192.168.0.100/24
            IP4.GATEWAY:192.168.0.1
            IP4.ROUTE[1]:dst = 192.168.0.0/24, nh = 0.0.0.0, mt = 100
            IP4.ROUTE[2]:dst = 0.0.0.0/0, nh = 192.168.0.1, mt = 20100
            IP4.DNS[1]:192.168.0.1
            IP6.ADDRESS[1]:
            IP6.GATEWAY:
            IP6.ROUTE[1]:dst = fe80::/64, nh = ::, mt = 1024 */
        const lines = ethernetData.trim().split("\n");
        let conn_name = "Undefined", conn_status = 20, conn_ipv4 = "";
        for(const line of lines) {
            const key_val = line.split(":");
            if(key_val[0] == "GENERAL.CONNECTION") {
                conn_name = key_val[1];
            } else if (key_val[0] == "GENERAL.STATE") {
                const status = key_val[1].split(" ")[0];
                conn_status = parseInt(status) ?? 20;
            } else if (key_val[0].includes("IP4.ADDRESS")) {
                const ip = key_val[1].split("/")[0];
                conn_ipv4 = ip;
            }
        }
        root.ethernet = wiredNetworkComponent.createObject(root, {
            name: conn_name,
            status: conn_status,
            ipv4: conn_ipv4,
        })
    }

    function processDevices(devicesString: string) {
        const devices = devicesString.trim().split("\n");
        for(const device of devices) {
            const props = device.split(":");
            if(props[1]?.toLowerCase() == "ethernet") {
                root.ethernetInterfaceName = props[0] ?? ""
            } else if (props[1]?.toLowerCase() == "wifi") {
                root.wifiInterfaceName = props[0] ?? ""
            }
        }
    }

    function updateWifiNetworks(networksString: string) {
        const networks = networksString.trim().split("\n").map(line => {
            const parts = line.split(":");
            if (parts.length < 4) return null; 
            return wifiNetworkComponent.createObject(root, {
                name: parts[0],
                strength: parseInt(parts[2]),
                connected: (parts[3] === "yes" || parts[3] === "sí" || parts[3] === "si" ),
            });
        }).filter(n => n !== null);
        root.wifiNetworksList = networks;
    }

    function update() {
        if(getWifiNetworksProcess.running == false) {
            getWifiNetworksProcess.running = true;
        }
        if(getEthernetStatusProcess.running == false) {
            getEthernetStatusProcess.running = true;
        }
        if(getWifiStatusProcess.running == true) {
            getWifiStatusProcess.running = true;
        }
    }

    function switchWifiPower() {
        switchWifiPowerProcess.status = !switchWifiPowerProcess.status;
        switchWifiPowerProcess.running = true;
        root.wifiActive = switchWifiPowerProcess.status;
    }

    function connectToNetwork(network: WifiNetwork, password: string) {
        let net = root.wifiNetworksList.find(net => net.name = network?.name);
        if(network === undefined || net === null) {
            console.warn("Network is null, cannot connect.");
            return;
        }
        if (network.connected) {
            return;
        } else {
            networkConnectProcess.networkName = network.name;
            networkConnectProcess.running = true;
            networkConnectProcess.write(password);
        }
    }

    function disconnectFormNetwork(network: WifiNetwork) {
        let net = root.wifiNetworksList.find(net => net.name = network?.name);
        if(network === undefined || net === null) {
            console.warn("No active network to disconnect from.");
            return; 
        }
        networkDisconnectProcess.networkName = net.name;
        networkDisconnectProcess.running = true;
    }

    function getNetworkStrenghtIcon(network: WifiNetwork): string {
        return NetworkIcons.getIconForStrength(network?.strength ?? -1)
    }

    function getActiveNetworkStrenghtIcon(): string {
        return getNetworkStrenghtIcon(root?.activeWifiNetwork ?? null);
    }

    function getEthernetStatusIcon() {
        return NetworkIcons.getIconForEthernet(root.ethernet.status)
    }

    Timer {
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            getDevicesNameProcess.running = true
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: root.update()
    }

    Process {
        id: getDevicesNameProcess
        command: ["nmcli", "-t", "-f", "DEVICE,TYPE", "device"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                root.processDevices(text)
            }
        }
    }

    Process {
        id: getEthernetStatusProcess
        command : ["nmcli", "-t", "device", "show", root.ethernetInterfaceName]
        stdout: StdioCollector {
            onStreamFinished: () => {
                root.processEthernetData(text)
            }
        }
    }

    Process {
        id: getWifiNetworksProcess
        command: ["nmcli", "-t", "-f", "SSID,SECURITY,SIGNAL,ACTIVE", "device", "wifi"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: () => {
                root.updateWifiNetworks(text);
            }
        }
    }

    Process {
        id: switchWifiPowerProcess
        property bool status: !root.wifiActive;
        command: ["nmcli", "radio", "wifi", status ? "on" : "off"]
        running: false
    }

    Process {
        id: getWifiStatusProcess
        command: ["nmcli", "-t", "-f", "wifi", "radio"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: () => {
                root.wifiActive = (text.trim() === "enabled");
            }
        }
    }

    Process {
        id: networkConnectProcess
        property string networkName: "";
        property string password: "";
        command: ["nmcli", "con", "up", "id", networkName];
        stdinEnabled: true
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(text)
            }
        }
    }

    Process {
        id: networkDisconnectProcess
        property string networkName: "";
        command: ["nmcli", "con", "down", "id", networkName];
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(text)
            }
        }
    }

    component WifiNetwork: QtObject {
        property string name: ""
        property int strength: 0
        property bool connected: false
        property bool wired: false
    }
    Component {
        id: wifiNetworkComponent
        WifiNetwork {}
    }

    component WiredNetwork: QtObject {
        property string name: "Undefined"
        property int status: 20
        property string ipv4: ""
    }
    Component {
        id: wiredNetworkComponent
        WiredNetwork {}
    }
}