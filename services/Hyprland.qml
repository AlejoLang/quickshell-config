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
    // readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    readonly property int activeWsId: focusedWorkspace?.id ?? 1
    readonly property list<DesktopEntry> clients: []
    property DesktopEntry activeClient: null

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    function getClients(): void {
        clientsProcess.running = true;
        activeClientProcess.running = true;
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
            else
                root.getClients();
        }
    }

    Process {
        id: clientsProcess
        running: false
        command: ["hyprctl", "-j", "clients"]
        stdout: StdioCollector {
            onStreamFinished: {
                const jsonData = JSON.parse(text);
                for(const client of jsonData) {
                    const name = client.initialClass.toLowerCase().replace(/ /g, "-");
                    const app = DesktopEntries.applications.values.find(a => {
                        return a.id.toLowerCase() === name}) ?? null;
                    root.clients.push(app);
                }
                
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

    Component {
        id: clientComp

        Client {}
    }
}