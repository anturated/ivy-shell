import QtQuick.Layouts
import QtQuick

import Quickshell.Services.Mpris

import qs.ui.widgets
import qs.ui.custom
import qs.config
import qs.services

ColumnLayout {
    id: root

    spacing: Appearance.spacing.l

    // control buttons
    RowLayout {
        spacing: 20
        Layout.alignment: Qt.AlignHCenter

        Icon {
            text: "shuffle"
            available: Players.active?.shuffleSupported ?? false
            active: Players.active?.shuffle ?? false

            TapHandler {
                onTapped: {
                    if (Players.active?.shuffleSupported)
                        Players.active.shuffle = !Players.active.shuffle;
                }
            }
        }
        Icon {
            text: "skip_previous"
            available: Players.active?.canGoPrevious ?? false

            TapHandler {
                onTapped: {
                    if (Players.active?.canGoPrevious)
                        Players.active.previous();
                }
            }
        }
        CustomRect {
            id: play
            readonly property bool available: Players.active?.canTogglePlaying ?? false
            Layout.preferredHeight: 30
            Layout.preferredWidth: Layout.preferredHeight
            radius: Layout.preferredHeight / 2
            color: available ? Colors.on_background : Colors.outline
            Icon {
                text: (Players.active?.isPlaying ?? false) ? "pause" : "play_arrow"
                font.pointSize: Players.active?.isPlaying ? 17 : 23
                color: Colors.background
                anchors.centerIn: parent
            }

            TapHandler {
                onTapped: {
                    if (play.available)
                        Players.active.togglePlaying();
                }
            }
        }
        Icon {
            text: "skip_next"
            available: Players.active?.canGoNext ?? false

            TapHandler {
                onTapped: {
                    if (Players.active?.canGoNext)
                        Players.active.next();
                }
            }
        }
        Icon {
            text: Players.active?.loopState == MprisLoopState.Track ? "repeat_one" : "repeat"
            available: Players.active?.loopSupported ?? false
            active: Players.active?.loopState != MprisLoopState.None

            TapHandler {
                onTapped: {
                    if (!Players.active?.loopSupported)
                        return;

                    if (Players.active?.loopState == MprisLoopState.None)
                        Players.active.loopState = MprisLoopState.Playlist;
                    else if (Players.active?.loopState == MprisLoopState.Playlist)
                        Players.active.loopState = MprisLoopState.Track;
                    else if (Players.active?.loopState == MprisLoopState.Track)
                        Players.active.loopState = MprisLoopState.None;
                }
            }
        }
    }

    RowLayout {
        LenText {
            text: Time.formatDynamic(Players.active?.position ?? 0)
        }
        WigglySlider {
            id: slider
            property real customValue
            Layout.fillWidth: true
            Layout.preferredHeight: Appearance.toast.thickness * 2 / 3
            to: Players.active?.length ?? 100
            value: Players.active?.position ?? 0
            wiggle: false
            // wiggle: Players.active?.isPlaying ?? false
            onMoved: {
                customValue = value;
            }
            onPressedChanged: {
                if (!pressed && Players.active?.canSeek && Players.active?.positionSupported)
                    Players.active.position = customValue;
            }
        }
        LenText {
            text: Time.formatDynamic(Players.active?.length ?? 0)
        }
    }

    FrameAnimation {
        id: playbackUpdate
        running: (Players.active?.isPlaying ?? false) && !slider.pressed
        // interval: 1000
        // repeat: true
        onTriggered: {
            Players.active.positionChanged();
        }
    }

    component Icon: MaterialIcon {
        property bool available: false
        property bool active: false
        color: available ? active ? Colors.primary : Colors.on_background : Colors.outline
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
    }

    component LenText: CustomText {
        color: Colors.on_background
    }
}
