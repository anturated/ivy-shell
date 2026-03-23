import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import qs.config
import qs.services
import qs.ui.custom
import qs.ui.toasts
import qs.ui.widgets

CustomRect {
    id: mi

    property bool big: false
    readonly property string cover: Players.active?.trackArtUrl ?? ""
    readonly property bool hasCover: Boolean(cover)
    readonly property real dimensions: big ? 100 : (Appearance.toast.thickness - parent.anchors.margins * 2)
    height: dimensions
    width: big ? 400 : ((hasCover ? dimensions : 0) + trackWidth.contentWidth + Appearance.spacing.m)

    onBigChanged: {
        if (big)
            coverAnim.restart();
        else {
            coverAnim.stop();
            coverLoader.rotation = 0;
        }
    }

    FrameAnimation {
        id: coverAnim

        onTriggered: {
            coverLoader.rotation += 10 * frameTime;
        }
    }

    Behavior on height {
        Animations.CaelestialNumber {}
    }

    Behavior on width {
        Animations.CaelestialNumber {}
    }

    // anchors.left: parent.left
    // anchors.right: parent.right

    // bg image
    Loader {
        active: mi.hasCover
        sourceComponent: FadedImage {
            source: Players.active.trackArtUrl
            width: mi.width
            height: mi.dimensions
            anchors.top: parent.top

            leftStart: 0.0
            leftEnd: 0.5
            leftIntensity: 0.8
            bottomStart: 0.0
            bottomEnd: 0.9
            topStart: 0.0
            topEnd: 0.1
            topIntensity: 0.5
            rightStart: 0.0
            rightEnd: 0.03
            rightIntensity: 0.5
            Behavior on height {
                Animations.CaelestialNumber {}
            }
            opacity: mi.big ? 1 : 0
            radius: Appearance.toast.rounding

            layer.enabled: true
            layer.effect: MultiEffect {
                brightness: -0.5
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: mi.big ? Appearance.spacing.xl : Appearance.spacing.m
        // cover
        Loader {
            id: coverLoader

            active: mi.hasCover
            visible: active
            readonly property real dynOffset: mi.big ? 11 : 0
            Layout.preferredHeight: dimensions - dynOffset
            Layout.preferredWidth: dimensions - dynOffset
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.topMargin: dynOffset
            Layout.leftMargin: mi.big ? 20 : 0

            Behavior on Layout.preferredWidth {
                Animations.CaelestialNumber {}
            }
            Behavior on Layout.preferredHeight {
                Animations.CaelestialNumber {}
            }

            Behavior on Layout.topMargin {
                Animations.CaelestialNumber {}
            }
            Behavior on Layout.leftMargin {
                Animations.CaelestialNumber {}
            }
            sourceComponent: Image {
                id: coverImg
                height: parent.height
                width: parent.width
                source: cover

                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: ShaderEffectSource {
                        sourceItem: Rectangle {
                            height: coverLoader.Layout.preferredHeight
                            width: coverLoader.Layout.preferredWidth
                            radius: mi.big ? mi.dimensions / 2 : Appearance.toast.rounding
                            Behavior on radius {
                                Animations.CaelestialNumber {}
                            }
                        }
                    }
                }
            }
        }

        // HACK: many animations can probably be removed

        // name/artist
        Item {
            Layout.preferredHeight: dimensions
            Behavior on Layout.preferredHeight {
                Animations.CaelestialNumber {}
            }
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft

            Item {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: trackName.contentHeight + offset
                property real offset: big ? trackArtist.contentHeight : 0

                CustomText {
                    id: trackArtist
                    text: Players.active?.trackArtist ?? "Nothing to play..."
                    anchors.bottom: parent.bottom
                    font.pointSize: 11
                    font.bold: true
                    visible: opacity > 0
                    opacity: mi.big ? 1 : 0
                    Behavior on opacity {
                        Animations.CaelestialNumber {}
                    }
                    font.family: "Maple Mono CN"
                }

                CustomText {
                    id: trackWidth
                    text: Players.active?.trackTitle ?? "牛鼎烹鸡"
                    font.bold: mi.big
                    font.pointSize: mi.big ? 13 : 10
                    font.family: "Maple Mono CN"
                    visible: false
                }

                CustomText {
                    id: trackName
                    text: Players.active?.trackTitle ?? "牛鼎烹鸡"
                    color: Colors.on_background
                    font.bold: mi.big
                    font.pointSize: mi.big ? 13 : 10
                    font.family: "Maple Mono CN"
                    Behavior on font.pointSize {
                        Animations.CaelestialNumber {}
                    }

                    anchors.top: parent.top
                }

                Behavior on offset {
                    Animations.CaelestialNumber {}
                }
            }
        }
    }
}
