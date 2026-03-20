pragma ComponentBehavior: Bound

import QtQuick
import qs.config

// wrapper for Text, adds animations and whatnot
Text {
    id: root

    property bool skipAnimation: false

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: Colors.current.tertiary
    font.family: "Monaspace Argon"
    font.pointSize: 10

    // animations
    Behavior on color {
        enabled: !root.skipAnimaiton
        Animations.CaelestialColor {}
    }
}
