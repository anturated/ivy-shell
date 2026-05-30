pragma Singleton

import Quickshell
import Quickshell.Networking

Singleton {
    readonly property bool wifiOn: Networking.wifiEnabled && Networking.wifiHardwareEnabled
    readonly property list<NetworkDevice> devices: Networking.devices.values
    readonly property list<NetworkDevice> connectedDevices: devices.filter(d => d.state == ConnectionState.Connected)
    readonly property WifiDevice connectedWifiDevice: connectedDevices.find(d => d.type == DeviceType.Wifi)
    readonly property int strength: connectedWifiDevice.networks.values.find(n => n.connected).signalStrength * 100 ?? -1

    readonly property bool available: connectedDevices.length > 0 || wifiOn

    readonly property string iconText: {
        // show issues first
        if (Networking.connectivity == NetworkConnectivity.Portal)
            return "captive_portal";
        if (Networking.connectivity == NetworkConnectivity.Unknown)
            return "globe_2_question";
        if (Networking.connectivity == NetworkConnectivity.Limited)
            return "globe_2_cancel";

        // then if we're connected
        if (connectedDevices.length > 0) {
            // wifi
            if (strength >= 0) {
                if (strength >= 80)
                    return "network_wifi";
                if (strength >= 60)
                    return "network_wifi_3_bar";
                if (strength >= 40)
                    return "network_wifi_2_bar";
                if (strength >= 20)
                    return "network_wifi_1_bar";
                return "signal_wifi_0_bar";
            }
            // wired
            return "cable";
        }

        // if something's on
        if (wifiOn)
            return "signal_wifi_off";
        // no luck
        return "plug_connect";
    }
}
