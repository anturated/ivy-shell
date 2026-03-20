import Quickshell
import QtQuick

import "Workspaces" as Workspaces
import "Dashboard" as Dashboard

Item {
    id: root

    required property ShellScreen screen

    Workspaces.Toast {
        collapseTo: ToastWrapper.Left
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        screen: root.screen
    }

    Dashboard.Toast {
        collapseTo: ToastWrapper.Top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }
}
