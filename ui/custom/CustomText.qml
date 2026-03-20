pragma ComponentBehavior: Bound

import QtQuick
import "../config"

// wrapper for Text, adds animations and whatnot
Text {
    id: root

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: Colors.current.tertiary
    font.family: "Monaspace Argon"
    font.pointSize: 10

    // animations
}
