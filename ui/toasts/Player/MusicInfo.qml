import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import qs.config
import qs.services
import qs.ui.custom
import qs.ui.toasts
import qs.ui.widgets

CustomClipRect {
    id: mi

    property bool big: false
    readonly property string cover: Players.active.trackArtUrl
    readonly property bool hasCover: Boolean(cover)
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

            active: hasCover
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
                source: cover

                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: ShaderEffectSource {
                        sourceItem: Rectangle {
                            height: coverLoader.Layout.preferredHeight
                            width: coverLoader.Layout.preferredWidth
                            radius: mi.big ? mi.dimensions / 2 : radius
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
