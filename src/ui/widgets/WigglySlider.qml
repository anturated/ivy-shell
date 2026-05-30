import QtQuick
import QtQuick.Controls

import qs.ui.custom
import qs.config

Slider {
    id: root

    from: 0
    to: 100

    property int barThickness: Appearance.spacing.m
    property string leftBarColor: Colors.primary
    property string rightBarColor: Colors.outline_variant
    property int knobThickness: Appearance.spacing.m
    property string knobColor: leftBarColor
    property bool wiggle: false
    property int gap: Appearance.spacing.m
    property real frequency: 5

    property real wiggleSmoothingMod: wiggle ? 1 : 0

    // override elements (https://doc.qt.io/qt-6/qml-qtquick-controls-slider-members.html)
    // the knob you drag
    handle: CustomRect {
        id: knob

        color: root.knobColor
        radius: width / 2
        x: root.visualPosition * (root.availableWidth - width)
        implicitWidth: root.knobThickness
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
                active: root.wiggleSmoothingMod > 0
                anchors.fill: parent

                sourceComponent: CommonWave {
                    color: root.leftBarColor
                }
            }

            Loader {
                active: root.wiggleSmoothingMod == 0
                height: root.barThickness
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                sourceComponent: CustomRect {
                    color: root.leftBarColor
                    radius: height / 2
                }
            }
        }
        // right part
        Item {
            id: bar
            anchors.right: parent.right
            implicitWidth: root.width - knob.x - knob.width - root.gap
            height: root.height

            Loader {
                active: root.wiggleSmoothingMod > 0
                anchors.fill: parent

                sourceComponent: CommonWave {
                    color: root.rightBarColor
                    phaseShift: knob.x + knob.width + root.gap
                }
            }

            Loader {
                active: root.wiggleSmoothingMod == 0
                height: root.barThickness
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                sourceComponent: CustomRect {
                    color: root.rightBarColor
                    radius: height / 2
                }
            }
        }
    }

    Behavior on wiggleSmoothingMod {
        Animations.CaelestialNumber {}
    }

    component CommonWave: WavyLine {
        amplitude: 0.3 * root.wiggleSmoothingMod
        fullLength: width + knob.width / 2 + root.gap
        frequency: fullLength / root.width * root.frequency
        thickness: root.barThickness
    }

    component CommonRect: CustomRect {
        radius: height / 2
        height: root.barThickness
        anchors.verticalCenter: parent.verticalCenter
    }
}
