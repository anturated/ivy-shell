import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Layouts

import qs.ui.custom
import qs.ui.toasts
import qs.ui.widgets
import qs.config
import qs.services

ToastWrapper {
    id: root

    readonly property var activeWS: Hypr.workspacesForScreen(root.screen).filter(w => w.active)[0]

    Timer {
        id: peek_timer
        interval: 1000
        running: false
        repeat: false

        onTriggered: {
            root.forceOpen = false;
        }
    }

    onActiveWSChanged: {
        root.forceOpen = true;
        peek_timer.restart();
    }

    CustomRect {
        id: container

        width: Appearance.toast.thickness
        height: layout.height + radius
        color: Colors.background
        radius: width / 2

        CustomRect {
            id: slider

            property Item target
            readonly property int margins: Appearance.spacing.m

            color: Colors.primary
            anchors.horizontalCenter: parent.horizontalCenter

            y: (target?.y + layout.y - margins) ?? 0
            height: (target?.height + margins * 2) ?? 0
            width: (target?.width + margins * 2) ?? 0
            radius: width / 2

            Behavior on y {
                Animations.BouncyNumber {}
            }
            Behavior on width {
                Animations.CaelestialNumber {}
            }
            Behavior on height {
                Animations.CaelestialNumber {}
            }
        }

        Connections {
            target: root.tapHandler

            function onTapped() {
                let event = root.tapHandler.point.position;

                let target = layout.children.find(c => {
                    let top = c.y + layout.y - layout.spacing / 2;
                    let bot = top + c.height + layout.spacing / 2;

                    return top < event.y && event.y < bot;
                });

                target?.activate();
            }
        }

        ColumnLayout {
            id: layout

            width: Appearance.toast.thickness
            anchors.centerIn: parent
            layer.enabled: true
            layer.smooth: true

            Repeater {
                model: ScriptModel {
                    values: Hypr.workspacesForScreen(root.screen)
                }

                Indicator {
                    bg_slider: slider
                }
            }
        }
    }
}
