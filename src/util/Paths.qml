pragma Singleton

import Quickshell

import qs.config

// heavy inspo from Caelestia
Singleton {
    readonly property string home: Quickshell.env("HOME")

    readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`}/eiddew`
    readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}/eiddew`
    readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/eiddew`
    readonly property string config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}/eiddew`

    readonly property string pictures: `${home}/Pictures`
    // readonly property string wallpapers: Config.paths.wallpapers
    // readonly property string imageCache: `${cache}/imagecache`
}
