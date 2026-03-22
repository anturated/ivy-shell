import QtQuick
import Quickshell.Widgets

import qs.config

// wrapper for Rectangle, adds animations and whatnot
ClippingRectangle {
    id: root

    color: "transparent"

    Behavior on color {
        Animations.CaelestialColor {}
    }
}
