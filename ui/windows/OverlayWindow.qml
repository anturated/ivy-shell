pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.ui.custom
import qs.ui.toasts

Variants {
    model: Quickshell.screens
    Scope {
        id: scope

        required property ShellScreen modelData

        CustomWindow {
            id: win
            name: `overlay-${scope.modelData}`
            screen: scope.modelData

            // reserve no space for the window
            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            // make only what we need clickable
            mask: Region {
                x: 0
                y: 0
                width: win.width
                height: win.height
                intersection: Intersection.Xor

                regions: mouseRegions.instances
            }

            anchors.top: true
            anchors.left: true
            anchors.right: true
            anchors.bottom: true

            Variants {
                id: mouseRegions
                model: toasts.children

                Region {
                    required property Item modelData

                    x: modelData.x
                    y: modelData.y
                    width: modelData.width
                    height: modelData.height

                    intersection: Intersection.Subtract
                }
            }

            ToastsLayout {
                id: toasts

                anchors.fill: parent
            }
        }
    }
}
