import QtQuick
import Quickshell

AnimatedImage {
    source: "root:/assets/dancing-cat.gif"
    width: 200 * 0.75
    height: 94 * 0.75
    // anchors.horizontalCenter: parent.horizontalCenter
    // anchors.top: timer_text.bottom

    // playing: root.isObserved

    Behavior on opacity {
        NumberAnimation {
            duration: 300
        }
    }

    // opacity: Player.current?.isPlaying ? 0.7 : 0
    // speed: vis.volumes.reduce((a, b) => a + b) / vis.volumes.length * 0.1 ?? 1
}
