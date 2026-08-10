import Quickshell
import QtQuick

import "Workspaces" as Workspaces
import "Dashboard" as Dashboard
import "Player" as Player
import "Tray" as Tray

Item {
    id: root

    required property ShellScreen screen
    readonly property bool anyExpanded: dashboard.expanded

    function collapseAll() {
        dashboard.expanded = false;
    }

    Workspaces.Toast {
        name: "workspaces"
        collapseTo: ToastWrapper.Left
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        screen: root.screen
    }

    Dashboard.Toast {
        id: dashboard

        name: "dash"
        collapseTo: ToastWrapper.Top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        screen: root.screen
    }

    Player.Toast {
        name: "player"
        collapseTo: ToastWrapper.Top
        anchors.left: parent.left
        anchors.top: parent.top

        screen: root.screen
        rx: 0
    }

    Tray.Toast {
        name: "tray"
        collapseTo: ToastWrapper.Top
        anchors.right: parent.right
        anchors.top: parent.top

        screen: root.screen
        rx: screen.width - width
    }
}
