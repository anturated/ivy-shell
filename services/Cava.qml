pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.util

Singleton {
    id: root

    property bool active: true
    readonly property int quantity: 50
    readonly property int framerate: 60

    property list<int> bars

    readonly property string configPath: Paths.cache + "/cava_conf.toml"

    Component.onCompleted: {
        Quickshell.execDetached(["sh", "-c", `printf '
[general]
framerate=${root.framerate}
autosens = 1
overshoot = 20
bars=${root.quantity}
sleep_timer=3
[output]
channels=mono
method=raw
raw_target=/dev/stdout
data_format=ascii
ascii_max_range=100' > "${configPath}"`]);
    }

    // TODO: auto create cache folder

    Process {
        id: cava

        command: ["sh", "-c", `cava -p ${root.configPath}`]
        running: root.active

        stdout: SplitParser {
            onRead: text => {
                let volumes = text.split(";").map(v => Math.min(Math.max(v, 1), 100));
                root.bars = volumes;
            }
        }
    }
}
