import QtQuick

import qs.config

// thank you axenide
Canvas {
    id: root

    property string color: Colors.primary
    property real thickness: Appearance.spacing.m
    property real frequency: 2
    property real amplitude: 1
    property real fullLength: width
    property real phaseShift: 0
    property bool running: true

    readonly property bool shouldAnimate: running && visible && width > 0 && opacity > 0

    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);

        if (width <= 0 || height <= 0)
            return;

        var amp = (root.height * 0.5 - root.thickness) * amplitude;
        var freq = root.frequency;
        var phase = Date.now() / 400.0;
        var centerY = height / 2;

        ctx.strokeStyle = root.color;
        ctx.lineWidth = root.thickness;
        ctx.lineCap = "round";
        ctx.beginPath();

        for (var x = ctx.lineWidth / 2; x <= root.width - ctx.lineWidth / 2; x += 1) {
            var waveY = centerY + amp * Math.sin(freq * 2 * Math.PI * (x + root.phaseShift) / root.fullLength + phase);
            if (x === ctx.lineWidth / 2)
                ctx.moveTo(x, waveY);
            else
                ctx.lineTo(x, waveY);
        }

        ctx.stroke();
    }

    FrameAnimation {
        running: root.shouldAnimate
        onTriggered: root.requestPaint()
    }
}
