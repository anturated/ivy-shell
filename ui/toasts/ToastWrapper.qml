import Quickshell
import QtQuick

import qs.ui.custom
import qs.config
import qs.services

Item {
    id: root

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

    required property int collapseTo
    required property ShellScreen screen

    property bool forceOpen: false
    readonly property bool overshadowed: {
        // FIXME: optimize this, theres no need to do this like 8 times
        let ws = Hypr.workspacesForScreen(screen).find(w => w.active);
        let windows = Hypr.windowsForWorkspace(ws).map(w => w.lastIpcObject);
        let pos = root.mapToItem(null, 0, 0);

        // calculate stable position
        let dx = 0;
        let dy = 0;

        if (root.collapseTo === ToastWrapper.Left)
            dx = -root.anchors.leftMargin;

        if (root.collapseTo === ToastWrapper.Right)
            dx = root.anchors.rightMargin;

        if (root.collapseTo === ToastWrapper.Top)
            dy = -root.anchors.topMargin;

        if (root.collapseTo === ToastWrapper.Bottom)
            dy = root.anchors.bottomMargin;

        let stableX = pos.x + dx;
        let stableY = pos.y + dy;

        // see if it intersects with windows
        let intersects = windows.some(w => {
            if (!w.at)
                return false;

            let l1 = w.at[0];
            let r1 = w.at[0] + w.size[0];
            let t1 = w.at[1];
            let b1 = w.at[1] + w.size[1];

            let l2 = stableX + root.screen.x;
            let r2 = stableX + root.screen.x + root.width;
            let t2 = stableY + root.screen.y;
            let b2 = stableY + root.screen.y + contentItem.height + Appearance.toast.margin * 2;

            if (l1 > r2 || l2 > r1)
                return false;

            if (b1 < t2 || b2 < t1)
                return false;

            return true;
        });

        return intersects;
    }

    property alias tapHandler: th
    property alias hoverHandler: hh
    default property alias content: contentItem.data

    implicitWidth: contentItem.width + Appearance.toast.margin * 2
    implicitHeight: contentItem.height + Appearance.toast.margin * 2
    state: ToastWrapper.Hidden

    onForceOpenChanged: {
        if (forceOpen)
            state = ToastWrapper.Peek;
        else if (!hoverHandler.hovered && overshadowed)
            state = ToastWrapper.Hidden;
    }

    onOvershadowedChanged: {
        if (overshadowed && !hoverHandler.hovered && !forceOpen)
            root.state = ToastWrapper.Hidden;
        else if (!overshadowed)
            root.state = ToastWrapper.Peek;
    }

    Component.onCompleted: {
        root.state = root.overshadowed ? ToastWrapper.Hidden : ToastWrapper.Peek;
    }

    // CustomRect {
    //     id: visual
    //     color: Colors.primary
    //     anchors.fill: parent
    // }

    QtObject {
        id: internal

        readonly property int hOffset: contentItem.width + Appearance.toast.margin
        readonly property int vOffset: contentItem.height + Appearance.toast.margin
    }

    states: [
        State {
            name: ToastWrapper.Hidden
            PropertyChanges {
                root.anchors.leftMargin: root.collapseTo == ToastWrapper.Left ? -internal.hOffset : 0
                root.anchors.rightMargin: root.collapseTo == ToastWrapper.Right ? internal.hOffset : 0
                root.anchors.topMargin: root.collapseTo == ToastWrapper.Top ? -internal.vOffset : 0
                root.anchors.bottomMargin: root.collapseTo == ToastWrapper.Bottom ? internal.vOffset : 0
            }
        },
        State {
            name: ToastWrapper.Peek
            PropertyChanges {
                root.anchors.leftMargin: 0
                root.anchors.rightMargin: 0
                root.anchors.topMargin: 0
                root.anchors.bottomMargin: 0
            }
        }
    ]

    HoverHandler {
        id: hh
        // TODO: put this and onOvershadowed under one function and call
        onHoveredChanged: {
            if (hovered)
                root.state = ToastWrapper.Peek;
            else if (!root.forceOpen && root.overshadowed)
                root.state = ToastWrapper.Hidden;
        }
    }

    TapHandler {
        id: th
    }

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

    // this is for children ( children go here )
    Item {
        id: contentItem

        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
    }
}
