pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property UPowerDevice bat: UPower.displayDevice
    readonly property int charge: bat.ready ? bat.percentage * 100 : 404
    readonly property bool ac: !UPower.onBattery
}
