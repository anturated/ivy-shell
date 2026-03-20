import qs.config

// icons for... pretty much everything
CustomText {
    property real fill
    property int grade: -25

    color: Colors.current.secondary
    font.family: "Material Symbols Rounded"
    font.pointSize: 17
    font.variableAxes: ({
            // TODO: copy this to appicons?
            FILL: fill.toFixed(1),
            GRAD: grade,
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })
}
