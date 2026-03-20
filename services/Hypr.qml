pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    readonly property HyprlandMonitor currentMonitor: Hyprland.focusedMonitor
    readonly property HyprlandWorkspace currentWorkspace: Hyprland.focusedWorkspace

    function hasFullscreen(screen: ShellScreen): bool {
        return Hyprland.monitorFor(screen)?.activeWorkspace.hasFullscreen ?? false;
    }

    function windowsForWorkspace(workspace: HyprlandWorkspace): list<var> {
        return Hyprland.toplevels.values.filter(i => i.workspace === workspace);
    }

    function workspacesForScreen(screen: ShellScreen): list<var> {
        let monitor = Hyprland.monitorFor(screen);
        return Hyprland.workspaces.values.filter(w => w.monitor == monitor);
    }

    function monitorFor(screen: ShellScreen): HyprlandMonitor {
        return Hyprland.monitorFor(screen);
    }

    Connections {
        target: Hyprland

        // stolen from caelestia
        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;
            if (n.endsWith("v2"))
                return;

            if (["workspace", "moveworkspace", "activespecial", "focusedmon"].includes(n)) {
                Hyprland.refreshWorkspaces();
                Hyprland.refreshMonitors();
            } else if (["openwindow", "closewindow", "movewindow"].includes(n)) {
                Hyprland.refreshToplevels();
                Hyprland.refreshWorkspaces();
            } else if (n.includes("mon")) {
                Hyprland.refreshMonitors();
            } else if (n.includes("workspace")) {
                Hyprland.refreshWorkspaces();
            } else if (n.includes("window") || n.includes("group") || ["pin", "fullscreen", "changefloatingmode", "minimize"].includes(n)) {
                Hyprland.refreshToplevels();
            }
        }
    }
}
