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

    forceOpen: Power.charge <= 10

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
                text: Power.iconText
                color: {
                    if (Power.ac)
                        return Colors.primary;
                    if (Power.charge < 15)
                        return Colors.error;
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
            }
        }
    }

    component BaseIcon: MaterialIcon {
        font.pixelSize: 20
    }
}
