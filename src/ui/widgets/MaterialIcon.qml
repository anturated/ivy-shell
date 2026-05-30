import QtQuick

import qs.config
import qs.ui.custom

// icons for... pretty much everything
CustomText {
    property real fill
    property int grade: -25

    color: Colors.secondary
    font.family: Fonts.icons
    font.pixelSize: 24
    font.variableAxes: ({
            // TODO: copy this to appicons?
            FILL: fill.toFixed(1),
            GRAD: grade
            // opsz: fontInfo.pixelSize,
            // wght: fontInfo.weight
        })
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
