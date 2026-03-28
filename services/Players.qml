pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> list: Mpris.players.values
    readonly property var active: list.find(p => p.identity == "Spotify") ?? list[0]
}
