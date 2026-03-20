import Quickshell
import QtQuick

import "Workspaces" as Workspaces
import "Dashboard" as Dashboard

Item {
    Workspaces.Toast {
        collapseTo: ToastWrapper.Left
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
    }

    Dashboard.Toast {
        collapseTo: ToastWrapper.Top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }
}
