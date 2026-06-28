import QtQuick
import Quickshell.Hyprland

import qs.config
import qs.ui.custom

// uses mono font because non-mono have weird alignment
CustomText {
    id: root
    required property HyprlandToplevel modelData
    readonly property var lastIpcObject: modelData.lastIpcObject // LIO's type is a json object so idk

    property string cls: lastIpcObject.class ?? ""
    property string title: lastIpcObject.title ?? ""

    font.family: Fonts.nerd
    font.pixelSize: 19

    font.variableAxes: ({
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: {
        if (["Spotify", "spotify"].includes(cls))
            return "";
        else if (["Code", "code"].includes(cls))
            return "󰨞";
        else if (["dev.zed.Zed-Preview"].includes(cls))
            return "󱃖";
        else if (["thunar", "nemo", "org.gnome.Nautilus"].includes(cls) || title.includes("Yazi:"))
            return "";
        else if (["kitty", "floating-kitty"].includes(cls))
            if (title.includes(" - Nvim"))
                return "";
            else if (title.includes("docker compose"))
                return "";
            else
                return "󰅭";
        else if (cls == "steam")
            return "󰓓";
        else if (["zen", "vivaldi-stable"].includes(cls))
            return "󰈹";
        else if (cls == "vesktop")
            return "";
        else if (["org.telegram.desktop"].includes(cls))
            return "";
        else if (["Signal"].includes(cls))
            return "󰭹";
        else if (["com-atlauncher-App"].includes(cls))
            return "󰍳";
        else if (["TradingView"].includes(cls))
            return "";
        else if (["com.usebottles.bottles"].includes(cls))
            return "";
        else if (cls.includes("steam_app_"))
            return "󰊗";
        else if (cls == "org.pulseaudio.pavucontrol")
            return "󱀞";
        else if (cls == "mpv")
            return "";
        else if (cls == "anytype")
            return "";
        else
            return "";
    }
}
