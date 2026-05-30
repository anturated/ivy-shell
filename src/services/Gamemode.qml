pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool active: false
    property bool _sawClientCount: false

    onActiveChanged: print(active)

    Process {
        command: ["busctl", "--user", "monitor", "com.feralinteractive.GameMode"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                if (line.includes('"ClientCount"')) {
                    root._sawClientCount = true;
                    return;
                }
                if (root._sawClientCount) {
                    const match = line.match(/INT32\s+(\d+)/);
                    if (match) {
                        root._sawClientCount = false;
                        root.active = parseInt(match[1]) > 0;
                    }
                }
            }
        }
    }
}
