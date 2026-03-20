import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.ui.custom
import qs.ui.widgets
import qs.config

Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property ShellScreen modelData

        CustomWindow {
            id: win

            screen: scope.modelData
            aboveWindows: false
            name: `desktop-${scope.modelData.name}`

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            DesktopClock {
                y: 170
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // NOTE: animated images are unoptimized or somethign idk
            // switching workspaces and moving windows feels jittery
            //
            // DesktopGif {
            //     anchors.bottom: parent.bottom
            //     anchors.left: parent.left
            //     anchors.margins: 30
            // }
        }
    }
}
