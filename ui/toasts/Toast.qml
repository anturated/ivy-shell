import Quickshell
import QtQuick

import qs.ui.custom
import qs.config

Item {
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

    CustomRect {
        id: visual
        color: Colors.primary
        anchors.fill: parent
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered)
                visual.color = Colors.tertiary;
            else
                visual.color = Colors.primary;
        }
    }

    // this is for children ( children go here )
    Item {
        id: contentItem

        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
    }
}
