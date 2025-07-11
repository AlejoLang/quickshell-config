pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root
    property list<DisplayComp> displays

    function setBrightness(display, value) {
        if(setBrightnessProcess.running) {
            return
        }
        if (display && display.name && value >= 0 && value <= 1) {
            setBrightnessProcess.display = display;
            setBrightnessProcess.set = `${value * 100}%`;
            setBrightnessProcess.running = true;
        } else {
            console.error("Invalid display or brightness value");
        }
    }

    Timer {
        interval: 1
        running: true
        onTriggered: {
            getDisplaysProcess.running = true;
        }
    }

    Process {
        id: getDisplaysProcess
        running: false
        command: ["brightnessctl", "-l", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const backlights = text.split("\n").filter(line => line.includes("backlight"));
                const aux = []
                for (const disp of backlights) {
                    const parts = disp.split(",");
                    const display = {
                        name: parts[0] ?? "Unknown",
                        currentBrightness: parseFloat(parts[2]) ?? 0,
                        maxBrightness: parseFloat(parts[4]) ?? 0,
                    }
                    const displayObject = displayComponent.createObject(root, { lastIpcObject: display });
                    if (displayObject) {
                        aux.push(displayObject);
                    } else {
                        console.error("Failed to create display object for:", display);
                    }
                } 
                root.displays = aux;
            }
        }
    }

    Process {
        id: setBrightnessProcess
        running: false
        property DisplayComp display: null
        property string set: "0"
        command: ["brightnessctl", "-d", setBrightnessProcess.display.name, "set", setBrightnessProcess.set]
    }

    component DisplayComp: QtObject {
        required property var lastIpcObject
        readonly property string name: lastIpcObject.name
        readonly property real currentBrightness: lastIpcObject.currentBrightness
        readonly property real maxBrightness: lastIpcObject.maxBrightness
    }
    Component {
        id: displayComponent
        DisplayComp { }
    }
}