pragma Singleton

import Quickshell

Singleton {
    readonly property SystemClock sysClock: clock

    function format(format: string): string {
        return Qt.formatDateTime(clock.date, format);
    }

    function formatDynamic(seconds) {
        seconds = Math.floor(seconds); // remove fractional part

        const hrs = Math.floor(seconds / 3600);
        const mins = Math.floor((seconds % 3600) / 60);
        const secs = seconds % 60;

        const paddedSecs = secs.toString().padStart(2, '0');

        if (hrs > 0) {
            return `${hrs}:${mins}:${paddedSecs}`;
        } else {
            return `${mins}:${paddedSecs}`;
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
