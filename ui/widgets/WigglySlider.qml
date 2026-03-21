import QtQuick
import QtQuick.Controls

import qs.ui.custom
import qs.config

Slider {
    id: root

    from: 0
    to: 100

    property int barHeight: Appearance.spacing.m
    property int gap: Appearance.spacing.m

    // override elements (https://doc.qt.io/qt-6/qml-qtquick-controls-slider-members.html)
    // the knob you drag
    handle: CustomRect {
        id: knob

        color: Colors.primary
        radius: height / 2
        x: root.visualPosition * (root.availableWidth - width)
        implicitWidth: Appearance.spacing.m
        implicitHeight: root.height
    }

    // bar thingy
    background: Item {
        // left part
        Item {
            id: filled
            anchors.left: parent.left
            implicitWidth: knob.x - root.gap  // can't anchor :(
            height: root.height

            Loader {
                active: true
                anchors.fill: parent

                sourceComponent: CommonWave {}
            }
        }
        // right part
        Item {
            id: bar
            anchors.right: parent.right
            implicitWidth: root.width - knob.x - knob.width - root.gap
            height: root.height

            Loader {
                active: true
                anchors.fill: parent

                sourceComponent: CommonWave {
                    color: Colors.primary_container
                    phaseShift: knob.x + knob.width + root.gap
                }
            }
        }
    }

    component CommonWave: WavyLine {
        readonly property real freqMultiplier: 5
        amplitude: 0.5
        fullLength: width + knob.width / 2 + root.gap
        frequency: fullLength / root.width * freqMultiplier
    }

    component CommonRect: CustomRect {
        radius: height / 2
        height: root.barHeight
        anchors.verticalCenter: parent.verticalCenter
    }
}
