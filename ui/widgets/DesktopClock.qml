import QtQuick
import QtQuick.Layouts

import qs.ui.custom
import qs.services
import qs.config

ColumnLayout {
    id: layout
    spacing: 0

    // TODO: visualizers

    CustomClock {
        id: clock
    }

    component CustomClock: ColumnLayout {
        spacing: -13
        // time
        ClockText {
            text: Time.format("hh:mm")
            font.pointSize: 50
            Layout.alignment: Qt.AlignCenter
        }
        // date
        ClockText {
            text: Time.format("dddd, dd MMMM")
            font.pointSize: 12
            font.italic: true

            Layout.alignment: Qt.AlignCenter
        }
    }

    component ClockText: CustomText {
        color: Colors.on_background
        font.bold: true
        font.family: "Maple Mono CN"
    }
}
