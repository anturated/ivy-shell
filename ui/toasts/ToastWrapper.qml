import Quickshell
import QtQuick

import qs.ui.custom
import qs.config

Item {
    id: root

    enum Collapse {
        Top = 1,
        Bottom = 2,
        Left = 3,
        Right = 4
    }
    enum State {
        Hidden = 0,
        Peek = 1
    }

    required property int collapseTo

    property bool forceOpen: false

    default property alias content: contentItem.data

    implicitWidth: contentItem.width + Appearance.toast.margin * 2
    implicitHeight: contentItem.height + Appearance.toast.margin * 2
    state: ToastWrapper.Hidden

    onForceOpenChanged: {
        if (forceOpen)
            state = ToastWrapper.Peek;
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
            PropertyChanges {}
        }
    ]

    HoverHandler {
        onHoveredChanged: {
            if (hovered)
                root.state = ToastWrapper.Peek;
            else if (!root.forceOpen)
                root.state = ToastWrapper.Hidden;
        }
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
