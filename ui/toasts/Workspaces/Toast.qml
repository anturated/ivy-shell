import qs.ui.custom
import qs.ui.toasts
import qs.config

ToastWrapper {
    CustomRect {
        width: Appearance.toast.thickness
        height: 200
        color: Colors.background
        radius: Appearance.toast.rounding
    }
}
