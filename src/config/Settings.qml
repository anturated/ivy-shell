pragma Singleton

import Quickshell
import Quickshell.Io

import qs.util

Singleton {
    id: root

    property alias main: fileview

    FileView {
        id: fileview
        watchChanges: true
        path: `${Paths.config}/config.json`

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoadFailed: writeAdapter()

        JsonAdapter {
            id: adapter

            property string weatherLocation: ""
            property bool useTwelveHourClock: true
        }
    }
}
