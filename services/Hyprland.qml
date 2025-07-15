pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors
    readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel
    readonly property list<HyprlandToplevel> topLevels: Hyprland.toplevels.values
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    readonly property int activeWsId: focusedWorkspace?.id ?? 1
    property list<Client> clients
    property DesktopEntry activeClient: null
    property list<WorkspaceClients> workspacesTopLevels

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    function getClients(): void {
        clientsProcess.running = true;
        activeClientProcess.running = true;
    }

    function getClientsByWorkspace() {
        const aux = [];
        for (const workspace of root.workspaces.values) {
            const topLevel = root.topLevels.filter(c => {
                return c.workspace.id === workspace.id;
            });
            const customTopLevel = topLevel.map(tl => {
                return customHyprlandTopLevelComp.createObject(root, {
                    lastIpcObject: tl,
                    width: root.clients.find(c => c.address === tl.address)?.width || 0,
                    height: root.clients.find(c => c.address === tl.address)?.height || 0,
                    y: root.clients.find(c => c.address === tl.address)?.y || 0,
                    x: root.clients.find(c => c.address === tl.address)?.x || 0
                });
            });
            if (customTopLevel.length > 0) {
                const workspaceClients = workspaceClientsComp.createObject(root, {
                    workspace: workspace,
                    topLevels: customTopLevel
                });
                aux.push(workspaceClients);
            }
        }
        root.workspacesTopLevels = aux;
    }

    Timer {
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            Hyprland.refreshMonitors();
            Hyprland.refreshWorkspaces();
            Hyprland.refreshToplevels();
            root.getClients()
            root.getClientsByWorkspace();
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (event.name.endsWith("v2"))
                return;

            if (event.name.includes("mon"))
                Hyprland.refreshMonitors();
            else if (event.name.includes("workspace"))
                Hyprland.refreshWorkspaces();
            else {
                Hyprland.refreshToplevels();
                root.getClients();
                root.getClientsByWorkspace()
            }
        }
    }

    Process {
        id: clientsProcess
        running: false
        command: ["hyprctl", "-j", "clients"]
        stdout: StdioCollector {
            onStreamFinished: {
                const jsonData = JSON.parse(text);
                const aux = []
                for(const client of jsonData) {
                    client.address = client.address.replace("0x", "")
                    const newClient = clientComp.createObject(root, {
                        lastIpcObject: client
                    });
                    aux.push(newClient);
                }
                root.clients = aux;
            }
        }
    }

    Process {
        id: activeClientProcess
        running: false
        command: ["hyprctl", "-j", "activewindow"]
        stdout: StdioCollector {
            onStreamFinished: {
                const jsonData = JSON.parse(text);
                if (jsonData.initialClass !== undefined) {
                    const name = jsonData.initialClass.toLowerCase().replace(/ /g, "-");
                    const app = DesktopEntries.applications.values.find(a => {
                        return a.id.toLowerCase() === name}) ?? null;
                    root.activeClient = app;
                } else {
                    root.activeClient = null;
                }
            }
        }
    }

    component Client: QtObject {
        required property var lastIpcObject
        readonly property string address: lastIpcObject.address
        readonly property string wmClass: lastIpcObject.class
        readonly property string title: lastIpcObject.title
        readonly property string initialClass: lastIpcObject.initialClass
        readonly property string initialTitle: lastIpcObject.initialTitle
        readonly property int x: lastIpcObject.at[0]
        readonly property int y: lastIpcObject.at[1]
        readonly property int width: lastIpcObject.size[0]
        readonly property int height: lastIpcObject.size[1]
        readonly property HyprlandWorkspace workspace: Hyprland.workspaces.values.find(w => w.id === lastIpcObject.workspace.id) ?? null
        readonly property HyprlandMonitor monitor: Hyprland.monitors.values.find(m => m.id === lastIpcObject.monitor) ?? null
        readonly property bool floating: lastIpcObject.floating
        readonly property bool fullscreen: lastIpcObject.fullscreen
        readonly property int pid: lastIpcObject.pid
        readonly property int focusHistoryId: lastIpcObject.focusHistoryID
    }

    component CustomHyprlandTopLevel: QtObject {
        required property var lastIpcObject
        readonly property string address: lastIpcObject.address
        readonly property string title: lastIpcObject.title
        readonly property var wayland: lastIpcObject.wayland
        property var width
        property var height
        property var x
        property var y
    }

    component WorkspaceClients: QtObject {
        property HyprlandWorkspace workspace
        property list<CustomHyprlandTopLevel> topLevels
    }

    Component {
        id: clientComp
        Client {}
    }
    Component {
        id: workspaceClientsComp
        WorkspaceClients {
            
        }
    }
    Component {
        id: customHyprlandTopLevelComp
        CustomHyprlandTopLevel {}
    }
}