import QtQuick
import Quickshell

import qs.config
import qs.services
import qs.ui.custom
import qs.ui.toasts

ToastWrapper {
    CustomRect {
        width: clock.contentWidth + 30
        height: Appearance.toast.thickness
        color: Colors.background
        radius: Appearance.toast.rounding

        Clock {
            id: clock
        }
    }

    component Clock: CustomText {
        text: Time.format("ddd, dd MMM hh:mm")
        color: Colors.on_background
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
