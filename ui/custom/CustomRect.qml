import QtQuick

import qs.config

// wrapper for Rectangle, adds animations and whatnot
Rectangle {
    id: root

    color: "transparent"

    Behavior on color {
        Animations.CaelestialColor {}
    }
}
