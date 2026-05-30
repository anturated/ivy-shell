pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property UPowerDevice bat: UPower.displayDevice
    readonly property int charge: bat.ready ? bat.percentage * 100 : 404
    readonly property bool ac: !UPower.onBattery

    readonly property bool isPerformance: PowerProfile.profile == PowerProfiles.Performance
    readonly property bool isPowersave: PowerProfile.profile == PowerProfiles.PowerSaver

    readonly property string iconText: {
        if (charge > 0 && charge < 5)
            return "battery_android_0";
        if (charge >= 5 && charge < 20)
            return "battery_android_1";
        if (charge >= 20 && charge < 35)
            return "battery_android_2";
        if (charge >= 35 && charge < 50)
            return "battery_android_3";
        if (charge >= 50 && charge < 65)
            return "battery_android_4";
        if (charge >= 65 && charge < 80)
            return "battery_android_5";
        if (charge >= 80 && charge < 95)
            return "battery_android_6";
        if (charge >= 95)
            return "battery_android_full";
        return "battery_alert";
    }
}
