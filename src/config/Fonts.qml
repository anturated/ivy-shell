pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string maple: "Maple Mono"
    readonly property string monaspace: "Monaspace Argon"
    readonly property string icons: "Material Symbols Rounded"
    readonly property string nerd: "Symbols Nerd Font"
}
