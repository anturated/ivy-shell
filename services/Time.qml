pragma Singleton

import Quickshell

Singleton {
    readonly property SystemClock sysClock: clock

    function format(format: string): string {
        return Qt.formatDateTime(clock.date, format);
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
