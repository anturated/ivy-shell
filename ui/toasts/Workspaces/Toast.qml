import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Layouts

import qs.ui.custom
import qs.ui.toasts
import qs.ui.widgets
import qs.config
import qs.services

ToastWrapper {
    id: root

    required property ShellScreen screen

    CustomRect {
        id: container

        width: Appearance.toast.thickness
        height: layout.height + 30
        color: Colors.background
        radius: Appearance.toast.rounding

        CustomRect {
            id: slider

            property Item target
            readonly property int margins: Appearance.spacing.m

            color: Colors.primary
            anchors.horizontalCenter: parent.horizontalCenter

            y: (target?.y + layout.y - margins) ?? 0
            height: (target?.height + margins * 2) ?? 0
            width: (target?.width + margins * 2) ?? 0
            radius: width / 2

            Behavior on y {
                Animations.BouncyNumber {}
            }

            Behavior on width {
                Animations.CaelestialNumber {}
            }
            Behavior on height {
                Animations.CaelestialNumber {}
            }
        }

        ColumnLayout {
            id: layout

            width: Appearance.toast.thickness
            anchors.centerIn: parent
            layer.enabled: true
            layer.smooth: true

            Repeater {
                model: ScriptModel {
                    values: Hypr.workspacesForScreen(root.screen)
                }

                Indicator {
                    bg_slider: slider
                }
            }
        }
    }

    component Indicator: Item {
        id: indicator
        required property HyprlandWorkspace modelData
        required property Item bg_slider

        Layout.preferredHeight: childrenRect.height
        Layout.preferredWidth: childrenRect.width
        Layout.alignment: Qt.AlignCenter

        function checkActive() {
            if (indicator.modelData.active)
                indicator.bg_slider.target = indicator;
        }

        Component.onCompleted: {
            indicator.checkActive();
        }

        Connections {
            target: indicator.modelData

            function onActiveChanged() {
                indicator.checkActive();
            }
        }

        ColumnLayout {
            spacing: -3
            CustomText {
                id: wsName
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignCenter

                color: modelData.active ? Colors.on_primary : Colors.on_background
                font.pointSize: 12
                text: {
                    if (modelData.name.includes("special:"))
                        return "死";

                    const map = {
                        "1": "一",
                        "2": "二",
                        "3": "三",
                        "4": "四",
                        "5": "五",
                        "6": "六",
                        "7": "七",
                        "8": "八",
                        "9": "九",
                        "10": "十"
                    };

                    return map[modelData.name] ?? modelData.name;
                }
            }

            Repeater {
                model: indicator.modelData ? Hypr.windowsForWorkspace(indicator.modelData).map(w => w.lastIpcObject) : []

                AppIcon {
                    Layout.alignment: Qt.AlignCenter
                    color: indicator.modelData.active ? Colors.on_primary : Colors.on_background
                    skipAnimation: true
                    Behavior on color {
                        Animations.CaelestialColor {}
                    }
                }
            }
        }
    }
}
