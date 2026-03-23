pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property Spacings spacing: Spacings {}
    readonly property Radii raduis: Radii {}
    readonly property Toasts toast: Toasts {}

    component Toasts: QtObject {
        readonly property int thickness: 35
        readonly property int margin: 3
        readonly property int rounding: root.raduis.l
    }

    component Spacings: QtObject {
        readonly property int xs: 1
        readonly property int s: 2
        readonly property int m: 5
        readonly property int l: 10
        readonly property int xl: 20
    }

    component Radii: QtObject {
        readonly property int xs: 1
        readonly property int s: 2
        readonly property int m: 5
        readonly property int l: 10
        readonly property int xl: 12
    }
}
