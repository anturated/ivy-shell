pragma Singleton

import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool on: adapter?.state == BluetoothAdapterState.Enabled ?? false
    readonly property bool connected: adapter?.devices.values.some(d => d.connected)
}
