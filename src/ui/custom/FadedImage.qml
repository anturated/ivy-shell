import QtQuick
import QtQuick.Effects

import qs.ui.custom
import qs.config

// this is some quantum magic
// multiple AI were harmed in the making of this

CustomClipRect {
    id: shImg

    property alias source: img.source

    property real leftStart: 0.66
    property real leftEnd: 1.0
    property real leftIntensity: 1.0

    property real rightStart: 0
    property real rightEnd: 0
    property real rightIntensity: 1.0

    property real topStart: 0
    property real topEnd: 0
    property real topIntensity: 1.0

    property real bottomStart: 0
    property real bottomEnd: 0
    property real bottomIntensity: 1.0

    visible: opacity > 0

    Image {
        id: img
        anchors.fill: parent
        visible: false
        fillMode: Image.PreserveAspectCrop

        layer.enabled: true
    }

    Behavior on opacity {
        Animations.CaelestialNumber {}
    }

    ShaderEffect {
        anchors.fill: parent

        property var source: img
        property real leftStart: shImg.leftStart
        property real leftEnd: shImg.leftEnd
        property real leftIntensity: shImg.leftIntensity

        property real rightStart: shImg.rightStart
        property real rightEnd: shImg.rightEnd
        property real rightIntensity: shImg.rightIntensity

        property real topStart: shImg.topStart
        property real topEnd: shImg.topEnd
        property real topIntensity: shImg.topIntensity

        property real bottomStart: shImg.bottomStart
        property real bottomEnd: shImg.bottomEnd
        property real bottomIntensity: shImg.bottomIntensity

        fragmentShader: "root:util/shaders/FadedImage.frag.qsb"
        vertexShader: "root:util/shaders/FadedImage.vert.qsb"
    }
}
