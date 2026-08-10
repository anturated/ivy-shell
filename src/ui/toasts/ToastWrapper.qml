import Quickshell
import QtQuick

import qs.ui.custom
import qs.config
import qs.services

Item {
    id: root

    required property int collapseTo
    required property ShellScreen screen
    required property string name

    property bool forceOpen: false
    property bool flushEdge: false

    property alias tapHandler: th
    property alias hoverHandler: hh
    default property alias content: contentItem.data

    enum Collapse {
        Top = 10,
        Bottom = 11,
        Left = 12,
        Right = 13
    }
    enum State {
        Hidden = 0,
        Peek = 1,
        Full = 2
    }

    property real rx: {
        if (collapseTo === ToastWrapper.Top) {
            return sx + (sw - cw) / 2;
        } else if (collapseTo === ToastWrapper.Bottom) {
            return sx + (sw - cw) / 2;
        } else if (collapseTo === ToastWrapper.Left) {
            return sx;
        } else {
            return sx + sw - cw;
        }
    }

    property real ry: {
        if (collapseTo === ToastWrapper.Top) {
            return sy;
        } else if (collapseTo === ToastWrapper.Bottom) {
            return sy + sh - ch;
        } else if (collapseTo === ToastWrapper.Left) {
            return sy + (sh - ch) / 2;
        } else {
            return sy + (sh - ch) / 2;
        }
    }

    // grab once
    readonly property var ws: Hypr.workspacesForScreen(screen).find(w => w.active)
    readonly property var windows: Hypr.windowsForWorkspace(ws).map(w => w.lastIpcObject)
    readonly property var sw: screen.width
    readonly property var sh: screen.height
    readonly property var sx: screen.x
    readonly property var sy: screen.y
    readonly property var cw: root.width
    readonly property var ch: root.height

    readonly property bool overshadowed: windows.some(w => {
        if (!w.at)
            return false;

        const [wl, wt] = w.at;
        const [ww, wh] = w.size;

        // AABB intersection
        return rx < wl + ww && rx + cw > wl && ry < wt + wh && ry + ch > wt;
    })

    // ── visibility state ──────────────────────────────────────────────────────
    function _updateVisibility() {
        if (forceOpen || hh.hovered)
            root.state = "peek";
        else if (overshadowed)
            root.state = "hidden";
        else
            root.state = "peek";
    }

    onForceOpenChanged: _updateVisibility()
    onOvershadowedChanged: _updateVisibility()

    Component.onCompleted: _updateVisibility()

    // ── sizing ────────────────────────────────────────────────────────────────
    implicitWidth: contentItem.width + Appearance.toast.margin * 2
    implicitHeight: contentItem.height + Appearance.toast.margin * 2

    // ── states & animation ────────────────────────────────────────────────────
    state: "hidden"

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                root.anchors.leftMargin: collapseTo === ToastWrapper.Left ? -(contentItem.width + Appearance.toast.margin) : 0
                root.anchors.rightMargin: collapseTo === ToastWrapper.Right ? -(contentItem.width + Appearance.toast.margin) : 0
                root.anchors.topMargin: collapseTo === ToastWrapper.Top ? -(contentItem.height + Appearance.toast.margin) : 0
                root.anchors.bottomMargin: collapseTo === ToastWrapper.Bottom ? -(contentItem.height + Appearance.toast.margin) : 0
            }
        },
        State {
            name: "peek"
            PropertyChanges {
                root.anchors.leftMargin: 0
                root.anchors.rightMargin: 0
                root.anchors.topMargin: 0
                root.anchors.bottomMargin: 0
            }
        }
    ]

    Behavior on anchors.leftMargin {
        Animations.CaelestialNumber {}
    }
    Behavior on anchors.rightMargin {
        Animations.CaelestialNumber {}
    }
    Behavior on anchors.topMargin {
        Animations.CaelestialNumber {}
    }
    Behavior on anchors.bottomMargin {
        Animations.CaelestialNumber {}
    }

    // ── handlers ──────────────────────────────────────────────────────────────
    HoverHandler {
        id: hh
        onHoveredChanged: _updateVisibility()
    }

    TapHandler {
        id: th
    }

    // ── content ───────────────────────────────────────────────────────────────
    Item {
        id: contentItem

        readonly property real m: Appearance.toast.margin
        readonly property real vo: root.collapseTo === ToastWrapper.Top ? -1 : root.collapseTo === ToastWrapper.Bottom ? 1 : 0
        readonly property real ho: root.collapseTo === ToastWrapper.Left ? -1 : root.collapseTo === ToastWrapper.Right ? 1 : 0

        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.flushEdge ? m * vo : 0
        anchors.horizontalCenterOffset: root.flushEdge ? m * ho : 0

        Behavior on anchors.horizontalCenterOffset {
            Animations.CaelestialNumber {
                duration: Animations.durations.small
            }
        }

        Behavior on anchors.verticalCenterOffset {
            Animations.CaelestialNumber {
                duration: Animations.durations.small
            }
        }

        width: childrenRect.width
        height: childrenRect.height
    }
}
