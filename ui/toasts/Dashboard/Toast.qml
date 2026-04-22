pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell.Services.Notifications

import qs.config
import qs.services
import qs.ui.custom
import qs.ui.toasts

ToastWrapper {
    id: root

    property bool expanded: false
    forceOpen: expanded || notifTimer.running
    flushEdge: expanded

    Connections {
        target: root.tapHandler
        function onTapped() {
            root.expanded = true;
        }
    }

    Timer {
        id: notifTimer
        interval: 2000
        repeat: false
    }

    Connections {
        target: Notifs.server

        function onNotification(notif) {
            if (notif.lastGeneration)
                return;
            lastNotif = notif;
            notifTimer.restart();
        }
    }

    readonly property int dashW: Appearance.dashboard.width
    readonly property int dashH: Appearance.dashboard.height
    readonly property int peekW: clockText.contentWidth + 30
    readonly property int peekH: Appearance.toast.thickness
    readonly property int r: Appearance.toast.rounding

    property Notification lastNotif

    // wrapper so the slopes don't inflate contentItem's size
    Item {
        width: bg.width
        height: bg.height

        Wing {
            anchors.right: bg.left
            anchors.rightMargin: root.expanded ? 0 : -width
            anchors.top: bg.top
            side: "left"
            Behavior on anchors.rightMargin {
                Animations.CaelestialNumber {}
            }
        }

        Wing {
            anchors.left: bg.right
            anchors.leftMargin: root.expanded ? 0 : -width
            anchors.top: bg.top
            side: "right"
            Behavior on anchors.leftMargin {
                Animations.CaelestialNumber {}
            }
        }

        Rectangle {
            id: bg
            color: Colors.background

            width: root.expanded ? root.dashW : root.peekW
            height: root.expanded ? root.dashH : root.peekH

            // top corners flatten when docked flush to screen edge
            topLeftRadius: root.expanded ? 0 : root.r
            topRightRadius: root.expanded ? 0 : root.r
            bottomLeftRadius: root.r
            bottomRightRadius: root.r

            Behavior on width {
                Animations.CaelestialNumber {}
            }
            Behavior on height {
                Animations.CaelestialNumber {}
            }
            Behavior on topLeftRadius {
                Animations.CaelestialNumber {}
            }
            Behavior on topRightRadius {
                Animations.CaelestialNumber {}
            }

            CustomText {
                id: clockText
                text: notifTimer.running ? lastNotif.summary : Time.format("ddd, dd MMM hh:mm")
                color: Colors.on_background
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: (Appearance.toast.thickness - contentHeight) / 2
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: root.expanded ? 0 : 1
                visible: opacity > 0
                Behavior on opacity {
                    Animations.CaelestialNumber {}
                }
            }

            Loader {
                anchors.fill: parent
                active: root.expanded
                opacity: root.expanded ? 1 : 0
                visible: opacity > 0
                sourceComponent: DashboardView {}
                Behavior on opacity {
                    Animations.CaelestialNumber {}
                }
            }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: root.expanded
        }
    }

    component Wing: Shape {
        id: wing

        required property string side
        readonly property int size: root.r * 2.5
        width: size
        height: size

        rotation: side === "right" ? 270 : 0

        ShapePath {
            strokeWidth: -1
            fillColor: Colors.background

            startX: 0
            startY: 0

            PathArc {
                x: wing.size
                y: wing.size
                radiusX: wing.size
                radiusY: wing.size
            }

            PathLine {
                x: wing.size
                y: 0
            }
        }
    }

    component DashboardView: Item {
        id: dash
        property int activeTab: 0

        readonly property list<color> tabColors: [Colors.surface_container, Colors.secondary, Colors.tertiary, Colors.error]

        // tab strip on the right
        Column {
            id: tabBar
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: Appearance.spacing.l
            width: 36
            spacing: Appearance.spacing.m

            Repeater {
                model: dash.tabColors.length

                Rectangle {
                    required property int index
                    readonly property bool isActive: dash.activeTab === index

                    width: tabBar.width
                    height: tabBar.width
                    radius: isActive ? Appearance.raduis.m : Appearance.raduis.s
                    color: isActive ? Colors.primary : Colors.surface_container_high

                    Behavior on color {
                        Animations.CaelestialColor {}
                    }
                    Behavior on radius {
                        Animations.CaelestialNumber {}
                    }

                    TapHandler {
                        onTapped: dash.activeTab = index
                    }
                }
            }
        }

        // content pane
        Item {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: tabBar.left
            anchors.bottom: parent.bottom
            anchors.margins: Appearance.spacing.l

            Repeater {
                model: dash.tabColors

                Rectangle {
                    required property int index
                    required property color modelData

                    anchors.fill: parent
                    color: modelData
                    radius: Appearance.raduis.m
                    opacity: dash.activeTab === index ? 1 : 0
                    visible: opacity > 0
                    Behavior on opacity {
                        Animations.CaelestialNumber {}
                    }

                    CustomText {
                        text: Power.charge + "%"
                        color: Colors.on_background
                        font.family: "Maple Mono CN"
                        font.pointSize: 30
                    }
                }
            }
        }
    }
}
