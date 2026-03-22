import QtQuick.Layouts
import QtQuick

import qs.ui.widgets
import qs.ui.custom
import qs.config
import qs.services

ColumnLayout {
    id: root

    // CustomRect {
    //     color: Colors.secondary
    //     anchors.fill: parent
    // }

    // control buttons
    RowLayout {
        spacing: 30
        Layout.alignment: Qt.AlignHCenter

        Icon {
            text: "shuffle"
        }
        Icon {
            text: "skip_previous"
        }
        Icon {
            text: Players.active?.isPlaying ? "pause" : "play_arrow"
        }
        Icon {
            text: "skip_next"
        }
        Icon {
            text: "loop"
        }
    }

    RowLayout {
        LenText {
            text: Time.formatDynamic(Players.active.position)
        }
        WigglySlider {
            Layout.fillWidth: true
            Layout.preferredHeight: Appearance.toast.thickness * 2 / 3
            to: Players.active.length
            value: Players.active.position
            wiggle: Players.active.isPlaying
        }
        LenText {
            text: Time.formatDynamic(Players.active.length)
        }
    }

    Timer {
        id: playbackUpdate
        running: Players.active?.isPlaying ?? false
        interval: 1000
        repeat: true
        onTriggered: {
            Players.active.positionChanged();
        }
    }

    component Icon: MaterialIcon {
        color: Colors.primary
    }

    component LenText: CustomText {
        color: Colors.on_background
    }
}
