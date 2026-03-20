import Quickshell
import Quickshell.Wayland

// wrapper for PanelWindow, idk why we need this, this is pretty much stolen from caelestia
PanelWindow {
    required property string name
    color: "transparent"

    WlrLayershell.namespace: `ivy-${name}`
}
