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
                id: clock
                y: 170
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledVis {
                anchors.top: clock.bottom
                flipH: true
            }

            StyledVis {
                anchors.bottom: clock.top
                flipV: true
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

    component StyledVis: Visualizer {
        bars: 15
        width: clock.width
        anchors.horizontalCenter: clock.horizontalCenter
        height: 75 / 2
        color: Colors.on_background
        anchors.margins: Appearance.spacing.m
    }
}
