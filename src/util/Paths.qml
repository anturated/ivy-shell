pragma Singleton

import Quickshell

import qs.config

// heavy inspo from Caelestia
Singleton {
    readonly property string home: Quickshell.env("HOME")

    readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`}/ivy-shell`
    readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}/ivy-shell`
    readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/ivy-shell`
    readonly property string config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}/ivy-shell`

    readonly property string pictures: `${home}/Pictures`
    // readonly property string wallpapers: Config.paths.wallpapers
    // readonly property string imageCache: `${cache}/imagecache`
}
