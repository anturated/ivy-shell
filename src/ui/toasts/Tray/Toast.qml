pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.services
import qs.ui.custom
import qs.ui.toasts
import qs.ui.widgets

ToastWrapper {
    id: root

    forceOpen: Power.charge <= 10 && !Power.ac

    CustomClipRect {
        id: bg

        height: Appearance.toast.thickness
        width: layout.width + Appearance.spacing.m * 2

        radius: Appearance.toast.rounding
        color: Colors.background

        RowLayout {
            id: layout

            anchors.centerIn: parent
            spacing: Appearance.spacing.m

            BaseIcon {
                text: Network.iconText
                color: {
                    if (Network.available)
                        return Colors.secondary;
                    return Colors.outline;
                }
            }

            BaseIcon {
                text: {
                    if (Bluetooth.connected)
                        return "bluetooth_connected";
                    if (Bluetooth.on)
                        return "bluetooth";
                    return "bluetooth_disabled";
                }

                color: {
                    if (Bluetooth.on)
                        return Colors.secondary;
                    return Colors.secondary_container;
                }
            }

            BaseIcon {
                id: bat
                readonly property bool low: Power.charge < 15
                property bool blink: false

                text: Power.iconText
                color: {
                    if (Power.ac)
                        return Colors.primary;
                    if (bat.low)
                        return bat.blink ? Colors.background : Colors.error;
                    return Colors.secondary;
                }

                MaterialIcon {
                    text: "bolt"
                    color: Colors.outline_variant
                    visible: false // TODO: figure out colors

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 3.7
                    font.pixelSize: 10
                }

                Timer {
                    running: bat.low
                    interval: 500
                    repeat: true
                    onTriggered: {
                        bat.blink = !bat.blink;
                    }
                }
            }
        }
    }

    component BaseIcon: MaterialIcon {
        font.pixelSize: 20
    }
}
