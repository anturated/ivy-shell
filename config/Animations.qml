pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property QtObject curves: QtObject {
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
        readonly property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
    }

    readonly property QtObject durations: QtObject {
        readonly property real scale: 1
        readonly property int small: 200 * scale
        readonly property int normal: 400 * scale
        readonly property int large: 600 * scale
        readonly property int extraLarge: 1000 * scale
        readonly property int expressiveFastSpatial: 350 * scale
        readonly property int expressiveDefaultSpatial: 500 * scale
        readonly property int expressiveEffects: 200 * scale
    }

    component CaelestialNumber: NumberAnimation {
        easing.type: Easing.BezierSpline
        duration: Animations.durations.normal
        easing.bezierCurve: Animations.curves.expressiveEffects
    }

    component CaelestialColor: ColorAnimation {
        easing.type: Easing.BezierSpline
        duration: Animations.durations.normal
        easing.bezierCurve: Animations.curves.standard
    }
}
