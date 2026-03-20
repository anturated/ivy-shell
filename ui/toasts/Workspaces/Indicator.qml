import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Layouts

import qs.ui.custom
import qs.ui.toasts
import qs.ui.widgets
import qs.config
import qs.services

Item {
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

    function activate() {
        if (!modelData.active)
            modelData.activate();
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
        id: layout
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
