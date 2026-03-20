pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.services
import qs.config
import qs.ui.custom

Row {
    id: root

    required property int bars
    property bool flipV: false
    property bool flipH: false
    property string color: Colors.primary
    spacing: 3

    readonly property list<int> steps: {
        const result = new Array(root.bars);
        const step = (Cava.quantity) / (root.bars);

        for (let i = 0; i < root.bars; i++) {
            result[i] = Math.round(i * step);
        }
        if (root.flipH)
            return result.reverse();
        else
            return result;
    }

    Repeater {
        id: rectangles
        model: root.steps
        anchors.fill: parent

        CustomRect {
            required property int modelData
            readonly property int volume: Cava.bars[modelData] ?? 0

            color: volume <= 1 ? "transparent" : root.color
            radius: width / 2

            implicitWidth: (root.width - root.spacing * (root.bars - 1)) / root.bars
            implicitHeight: volume * root.height / 100

            Binding on anchors.bottom {
                value: rectangles.bottom
                when: !root.flipV
            }

            Binding on anchors.top {
                value: rectangles.top
                when: root.flipV
            }
        }
    }
}
