pragma Singleton

import Quickshell
import Quickshell.Io

import "subconfigs"
import qs.util

Singleton {
    id: root

    // FileView {
    //     id: fileview
    //     watchChanges: true
    //     path: `${Paths.config}/config.json`
    //
    //     onFileChanged: reload()
    //     onAdapterUpdated: writeAdapter()
    //     onLoadFailed: writeAdapter()
    //
    //     JsonAdapter {
    //         id: adapter
    //
    //         property ThemeConfig theme: ThemeConfig {}
    //         property PathsConfig paths: PathsConfig {}
    //     }
    // }
}
