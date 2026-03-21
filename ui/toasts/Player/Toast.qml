pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.services
import qs.ui.custom
import qs.ui.toasts
import qs.ui.widgets

ToastWrapper {
    id: root

    Timer {
        id: switchTimer
        interval: 500
        repeat: false
        running: false

        onTriggered: {
            bg.state = ToastWrapper.Full;
            root.forceOpen = true;
        }
    }

    Timer {
        id: collapseTimer
        interval: Animations.durations.normal
        repeat: false
        running: false

        onTriggered: {
            root.forceOpen = false;
        }
    }

    Connections {
        target: root.hoverHandler
        function onHoveredChanged() {
            if (root.hoverHandler.hovered) {
                switchTimer.restart();
                collapseTimer.stop();
            } else {
                switchTimer.stop();
                collapseTimer.restart();
                bg.state = ToastWrapper.Peek;
            }
        }
    }

    CustomClipRect {
        id: bg

        radius: Appearance.toast.rounding
        color: Colors.background

        Column {
            anchors.fill: parent
            anchors.margins: bg.state == ToastWrapper.Full ? Appearance.spacing.m : Appearance.spacing.s
            MusicInfo {
                big: bg.state == ToastWrapper.Full
            }
        }

        state: ToastWrapper.Peek
        states: [
            State {
                name: ToastWrapper.Peek
                PropertyChanges {
                    bg.width: 300
                    bg.height: Appearance.toast.thickness
                }
            },
            State {
                name: ToastWrapper.Full
                PropertyChanges {
                    bg.width: 400
                    bg.height: 300
                }
            }
        ]

        Behavior on width {
            Animations.CaelestialNumber {}
        }
        Behavior on height {
            Animations.CaelestialNumber {}
        }
    }
}
