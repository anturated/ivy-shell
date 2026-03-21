pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
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

    component MusicInfo: CustomClipRect {
        id: mi
        property bool big: false
        readonly property real dimensions: big ? 100 : (Appearance.toast.thickness - parent.anchors.margins * 2)
        height: dimensions

        Behavior on height {
            Animations.CaelestialNumber {}
        }

        anchors.left: parent.left
        anchors.right: parent.right

        FadedImage {
            source: Players.active.trackArtUrl
            width: mi.width
            height: mi.dimensions
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            // anchors.fill: parent
            Behavior on height {
                Animations.CaelestialNumber {}
            }
            opacity: mi.big ? 1 : 0
            radius: Appearance.toast.rounding
        }

        RowLayout {
            anchors.fill: parent
            // cover
            Loader {
                id: coverLoader

                active: bg.hasCover
                Layout.preferredHeight: dimensions
                Layout.preferredWidth: dimensions
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                Behavior on Layout.preferredWidth {
                    Animations.CaelestialNumber {}
                }
                Behavior on Layout.preferredHeight {
                    Animations.CaelestialNumber {}
                }
                sourceComponent: Image {
                    id: coverImg
                    height: parent.height
                    width: parent.width
                    source: bg.cover

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: ShaderEffectSource {
                            sourceItem: Rectangle {
                                height: coverLoader.Layout.preferredHeight
                                width: coverLoader.Layout.preferredWidth
                                radius: mi.big ? mi.dimensions / 2 : bg.radius
                                Behavior on radius {
                                    Animations.CaelestialNumber {}
                                }
                            }
                        }
                    }
                }
            }

            // name/artist
            Item {
                // FIXME: the text randomly waddles away to the center of free space for no reason
                Layout.preferredHeight: dimensions
                Behavior on Layout.preferredHeight {
                    Animations.CaelestialNumber {}
                }
                Layout.preferredWidth: childrenRect.width
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                Column {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Appearance.spacing.l

                    CustomText {
                        id: trackName
                        text: Players.active.trackTitle
                        color: Colors.on_background

                        Layout.alignment: big ? Qt.AlignBottom : Qt.AlignCenter
                    }

                    Loader {
                        active: mi.big
                        visible: active
                        sourceComponent: CustomText {
                            text: Players.active.trackArtist
                        }
                    }
                }
            }
        }
    }

    // this is some quantum magic
    // multiple AI were harmed in the making of this
    component FadedImage: CustomClipRect {
        id: shImg

        property alias source: img.source
        property real fadeStart: 0.66

        Image {
            id: img
            anchors.fill: parent
            visible: false
            fillMode: Image.PreserveAspectCrop
        }

        Behavior on opacity {
            Animations.CaelestialNumber {}
        }

        ShaderEffect {
            anchors.fill: parent

            property var source: img
            property real fadeStart: shImg.fadeStart

            fragmentShader: "root:util/shaders/FadedImage.frag.qsb"
            vertexShader: "root:util/shaders/FadedImage.vert.qsb"
        }
    }
}
