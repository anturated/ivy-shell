import Quickshell
import QtQuick

import qs.ui.custom
import qs.config
import qs.services

Item {
    id: root

    required property int collapseTo
    required property ShellScreen screen

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

    readonly property bool overshadowed: {
        const ws = Hypr.workspacesForScreen(screen).find(w => w.active);
        const windows = Hypr.windowsForWorkspace(ws).map(w => w.lastIpcObject);

        const sw = screen.width, sh = screen.height;
        const sx = screen.x, sy = screen.y;
        const cw = root.width, ch = root.height;

        let rx, ry;
        if (collapseTo === ToastWrapper.Top) {
            rx = sx + (sw - cw) / 2;
            ry = sy;
        } else if (collapseTo === ToastWrapper.Bottom) {
            rx = sx + (sw - cw) / 2;
            ry = sy + sh - ch;
        } else if (collapseTo === ToastWrapper.Left) {
            rx = sx;
            ry = sy + (sh - ch) / 2;
        } else {
            rx = sx + sw - cw;
            ry = sy + (sh - ch) / 2;
        }

        return windows.some(w => {
            if (!w.at)
                return false;
            const [wl, wt] = w.at;
            const [ww, wh] = w.size;
            // AABB intersection
            return rx < wl + ww && rx + cw > wl && ry < wt + wh && ry + ch > wt;
        });
    }

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
                root.anchors.rightMargin: collapseTo === ToastWrapper.Right ? (contentItem.width + Appearance.toast.margin) : 0
                root.anchors.topMargin: collapseTo === ToastWrapper.Top ? -(contentItem.height + Appearance.toast.margin) : 0
                root.anchors.bottomMargin: collapseTo === ToastWrapper.Bottom ? (contentItem.height + Appearance.toast.margin) : 0
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

        anchors.centerIn: !root.flushEdge ? parent : undefined
        anchors.top: (collapseTo === ToastWrapper.Top && root.flushEdge) ? parent.top : undefined
        anchors.bottom: (collapseTo === ToastWrapper.Bottom && root.flushEdge) ? parent.bottom : undefined
        anchors.left: (collapseTo === ToastWrapper.Left && root.flushEdge) ? parent.left : undefined
        anchors.right: (collapseTo === ToastWrapper.Right && root.flushEdge) ? parent.right : undefined

        anchors.topMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0

        width: childrenRect.width
        height: childrenRect.height
    }
}
