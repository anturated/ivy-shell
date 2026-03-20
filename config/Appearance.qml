pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property Spacings spacing: Spacings {}
    readonly property Toasts toast: Toasts {}

    component Toasts: QtObject {
        readonly property int thickness: 20
        readonly property int margin: 20
    }

    component Spacings: QtObject {
        readonly property int xs: 1
        readonly property int s: 2
        readonly property int m: 5
        readonly property int l: 10
        readonly property int xl: 12
    }
}
