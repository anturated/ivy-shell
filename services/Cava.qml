pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool active: true
    readonly property int quantity: 50
    readonly property int framerate: 60

    property list<int> bars

    Process {
        id: cava

        command: ["sh", "-c", `printf '[general]\nframerate=${root.framerate}\nbars=${root.quantity}\nsleep_timer=3\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100' | cava -p /dev/stdin`]
        running: root.active

        stdout: SplitParser {
            onRead: text => {
                let volumes = text.split(";").map(v => Math.min(Math.max(v, 1), 100));
                root.bars = volumes;
            // print(root.bars);
            }
        }

        // stderr: SplitParser {
        //     onRead: text => cava.running = false
        // }

        // on crash restart
        // onRunningChanged: {
        //     if (root.active && !running) {
        //         running = true;
        //     }
        //
        //     if (!running)
        //         root.bars = [0];
        // }
    }
}
