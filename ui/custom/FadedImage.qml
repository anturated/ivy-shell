import QtQuick

import qs.ui.custom
import qs.config

// this is some quantum magic
// multiple AI were harmed in the making of this

CustomClipRect {
    id: shImg

    property alias source: img.source
    property real fadeStart: 0.66
    visible: opacity > 0

    Image {
        id: img
        anchors.fill: parent
        visible: false
        fillMode: Image.PreserveAspectCrop
    }

    Behavior on opacity {
        Animations.CaelestialNumber {}
    }

    ShaderEffect {
        anchors.fill: parent

        property var source: img
        property real fadeStart: shImg.fadeStart

        fragmentShader: "root:util/shaders/FadedImage.frag.qsb"
        vertexShader: "root:util/shaders/FadedImage.vert.qsb"
    }
}
