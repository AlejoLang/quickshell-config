pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    property string format: "hh:mm:ss - dd/MM/yyyy"
    
    property string time: {
        Qt.formatDateTime(clock.date, format)
    }
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}