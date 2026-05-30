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

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
