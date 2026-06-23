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
import qs.ui.widgets

ToastWrapper {
    id: root

    property bool expanded: false
    forceOpen: expanded || notifTimer.running || collapseTimer.running
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

    Timer {
        id: collapseTimer
        interval: Animations.durations.normal
        repeat: false
        running: false
    }

    onExpandedChanged: {
        if (!root.expanded)
            collapseTimer.restart();
        else
            collapseTimer.stop();
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
    readonly property int peekW: clockText.width + 30
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
                Animations.CaelestialNumber {
                    duration: Animations.durations.small
                }
            }
        }

        Wing {
            anchors.left: bg.right
            anchors.leftMargin: root.expanded ? 0 : -width
            anchors.top: bg.top
            side: "right"
            Behavior on anchors.leftMargin {
                Animations.CaelestialNumber {
                    duration: Animations.durations.small
                }
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
                Animations.CaelestialNumber {
                    duration: Animations.durations.small
                }
            }
            Behavior on topRightRadius {
                Animations.CaelestialNumber {
                    duration: Animations.durations.small
                }
            }

            RowLayout {
                id: clockText

                readonly property bool showWeather: !root.overshadowed && !notifTimer.running

                spacing: Appearance.spacing.l
                height: Appearance.toast.thickness
                anchors.centerIn: parent

                MaterialIcon {
                    Layout.alignment: Qt.AlignVCenter

                    text: Weather.icon
                    color: Colors.on_background

                    font.pixelSize: 20
                    visible: clockText.showWeather
                }

                CustomText {
                    id: actualText

                    Layout.alignment: Qt.AlignVCenter

                    text: {
                        if (notifTimer.running)
                            return lastNotif.summary;

                        if (clockText.showWeather) {
                            Weather.reload();
                            return `${Weather.temp}, ${Weather.description}`;
                        }

                        return Time.format("ddd, dd MMM hh:mm");
                    }

                    color: Colors.on_background

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                opacity: root.expanded ? 0 : 1
                visible: opacity > 0
                Behavior on opacity {
                    Animations.CaelestialNumber {
                        duration: Animations.durations.normal / 2
                    }
                }
            }

            Loader {
                anchors.fill: parent
                opacity: root.expanded ? 1 : 0
                visible: opacity > 0
                active: visible
                sourceComponent: DashboardView {}
                Behavior on opacity {
                    Animations.CaelestialNumber {}
                }
            }
        }

        layer.enabled: false
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

        // notifs section
        CustomClipRect {
            id: notifs

            radius: Appearance.radius.l
            color: Colors.surface_container
            width: parent.width / 2

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: Appearance.spacing.l

            Flickable {
                anchors.fill: parent
                contentWidth: width
                contentHeight: notifsLayout.height
                anchors.margins: Appearance.spacing.m

                ColumnLayout {
                    id: notifsLayout
                    width: parent.width

                    Repeater {
                        model: Notifs.server.trackedNotifications.values

                        CustomClipRect {
                            id: notifObject
                            required property Notification modelData

                            Layout.preferredWidth: notifsLayout.width
                            Layout.preferredHeight: nc.height

                            color: Colors.surface
                            radius: Appearance.radius.m

                            Column {
                                id: nc
                                spacing: Appearance.spacing.xs
                                padding: Appearance.spacing.m
                                anchors.left: parent.left
                                anchors.right: parent.right

                                // title
                                CustomText {
                                    id: ns
                                    text: notifObject.modelData.summary
                                    color: Colors.on_background
                                    elide: Text.ElideRight
                                    font.weight: Font.Medium
                                    font.pixelSize: 15
                                }

                                CustomText {
                                    id: nb
                                    text: notifObject.modelData.body.slice(0, 300)
                                    color: Colors.outline
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    font.pixelSize: 14
                                    width: parent.width
                                    maximumLineCount: 3
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
