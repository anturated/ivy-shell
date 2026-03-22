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
        width: col.width + col.anchors.margins * 2

        Column {
            id: col
            // anchors.fill: parent
            anchors.left: parent.left
            anchors.top: parent.top
            width: musicInfo.width
            anchors.margins: bg.state == ToastWrapper.Full ? Appearance.spacing.m : Appearance.spacing.s
            spacing: 30

            MusicInfo {
                id: musicInfo
                big: bg.state == ToastWrapper.Full
            }

            Loader {
                id: controls
                anchors.left: parent.left
                anchors.right: parent.right

                opacity: bg.state == ToastWrapper.Full ? 1 : 0
                active: opacity > 0
                visible: active

                sourceComponent: PlayerControls {}

                Behavior on opacity {
                    Animations.CaelestialNumber {}
                }
            }
        }

        state: ToastWrapper.Peek
        states: [
            State {
                name: ToastWrapper.Peek
                PropertyChanges {
                    bg.height: musicInfo.dimensions + col.anchors.margins * 2
                }
            },
            State {
                name: ToastWrapper.Full
                PropertyChanges {
                    bg.height: musicInfo.dimensions + col.anchors.margins * 2 + controls.height + col.spacing
                }
            }
        ]

        Behavior on height {
            Animations.CaelestialNumber {}
        }
    }
}
