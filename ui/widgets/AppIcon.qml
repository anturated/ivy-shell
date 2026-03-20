import QtQuick
import Quickshell.Hyprland

import qs.config
import qs.ui.custom

// uses mono font because non-mono have weird alignment
CustomText {
    id: root
    required property var modelData

    property string cls: modelData.class ?? ""
    property string title: modelData.title ?? ""
    property int size: 17

    font.family: "MesloLGL Nerd Font Mono"
    font.pointSize: size

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: {
        if (["Spotify", "spotify"].includes(cls))
            return "";
        else if (["Code", "code"].includes(cls))
            return "󰨞";
        else if (["dev.zed.Zed-Preview"].includes(cls))
            return "󱃖";
        else if (["kitty", "floating-kitty"].includes(cls))
            if (title.includes(" - Nvim"))
                return "";
            else if (title.includes("docker compose"))
                return "";
            else
                return "󰅭";
        else if (cls == "thunar")
            return "";
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
        else
            return "";
    }
}

// "MesloLGL Nerd Font"
