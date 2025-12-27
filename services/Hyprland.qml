pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property list<HyprlandWorkspace> workspaces: Hyprland.workspaces.values
    readonly property list<HyprlandMonitor> monitors: Hyprland.monitors.values
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
        const aux = []
        for(const topLevel of Hyprland.toplevels.values) {
           if(Object.keys(topLevel.lastIpcObject).length) {
                const newClient = clientComp.createObject(root, {
                            lastIpcObject: topLevel.lastIpcObject,
                            address: topLevel.lastIpcObject.address.replace("0x", "")
                });
                aux.push(newClient);
           }
        }
        root.clients = aux;
        activeClientProcess.running = true;
    }

    function getClientsByWorkspace() {
        const aux = [];
        for (const workspace of root.workspaces) {
            const topLevel = [];
            for(const tl of root.topLevels) {
                if (tl.workspace?.id == workspace?.id) {
                    topLevel.push(tl);
                }
            }
            const customTopLevel = topLevel.map(tl => {
                let cl = null;
                for(const client of root.clients) {
                    if(client.address == tl.address) {
                        cl = client;
                        break;
                    }
                }
                const name = tl.lastIpcObject.initialClass.toLowerCase().replace(/ /g, "-");
                const app = DesktopEntries.applications.values.find(a => {
                        return a.id.toLowerCase() === name}) ?? null;
        
                return customHyprlandTopLevelComp.createObject(root, {
                    lastIpcObject: tl.lastIpcObject,
                    icon: app?.icon ?? "emblem-generic",
                    width: cl?.width || 0,
                    height: cl?.height || 0,
                    y: cl?.y || 0,
                    x: cl?.x || 0
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
            root.getClients();
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
        property string address: lastIpcObject.address
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
        property string address: lastIpcObject.address
        property string icon: "null"
        readonly property string title: lastIpcObject.title
        readonly property string wmClass: lastIpcObject.class
        readonly property string initialClass: lastIpcObject.initialClass
        readonly property string initialTitle: lastIpcObject.initialTitle
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