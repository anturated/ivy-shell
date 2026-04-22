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
            mask: toasts.anyExpanded ? null : mouseMask

            Region {
                id: mouseMask
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

            TapHandler {
                enabled: toasts.anyExpanded
                onTapped: {
                    const p = point.position;
                    const outside = toasts.children.every(toast => {
                        const r = toast.mapToItem(win.contentItem, 0, 0, toast.width, toast.height);
                        return p.x < r.x || p.x > r.x + r.width || p.y < r.y || p.y > r.y + r.height;
                    });
                    if (outside)
                        toasts.collapseAll();
                }
            }

            ToastsLayout {
                id: toasts

                anchors.fill: parent
                screen: scope.modelData
            }
        }
    }
}
