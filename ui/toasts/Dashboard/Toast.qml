import QtQuick
import Quickshell

import qs.config
import qs.ui.custom
import qs.ui.toasts

ToastWrapper {
    CustomRect {
        width: 300
        height: Appearance.toast.thickness
        color: Colors.background
    }
}
