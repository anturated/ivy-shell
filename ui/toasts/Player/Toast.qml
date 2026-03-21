import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

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
        }
    }

    Connections {
        target: root.hoverHandler
        function onHoveredChanged() {
            if (root.hoverHandler.hovered) {
                switchTimer.start();
            } else {
                switchTimer.stop();
                bg.state = ToastWrapper.Peek;
            }
        }
    }

    CustomClipRect {
        id: bg

        radius: Appearance.toast.rounding
        color: Colors.background

        readonly property string cover: Players.active.trackArtUrl
        readonly property bool hasCover: Boolean(cover)

        ColumnLayout {
            anchors.fill: parent
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

    component MusicInfo: RowLayout {
        id: mi
        property bool big: false
        spacing: Appearance.spacing.m

        Layout.alignment: (big ? Qt.AlignHCenter : Qt.AlignLeft) | Qt.AlignTop

        Behavior on x {
            Animations.CaelestialNumber {}
        }

        Loader {
            id: coverLoader
            Layout.preferredHeight: big ? 100 : Appearance.toast.thickness

            Layout.preferredWidth: height
            active: bg.hasCover
            sourceComponent: ClippingRectangle {
                radius: bg.radius
                Image {
                    height: parent.height
                    width: parent.width
                    source: bg.cover
                }
            }
        }

        ColumnLayout {
            Layout.preferredHeight: coverLoader.height

            CustomText {
                id: trackName
                text: Players.active.trackTitle
                color: Colors.on_background

                Layout.alignment: big ? Qt.AlignBottom : Qt.AlignCenter
            }

            Loader {
                active: mi.big
                visible: active
                Layout.alignment: Qt.AlignTop
                sourceComponent: CustomText {
                    text: Players.active.trackArtist
                }
            }
        }
    }
}
