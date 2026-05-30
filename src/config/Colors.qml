pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import qs.util

Singleton {
    // HACK: surely theres a better way right
    property alias background: autoloaded.background
    property alias error: autoloaded.error
    property alias error_container: autoloaded.error_container
    property alias inverse_on_surface: autoloaded.inverse_on_surface
    property alias inverse_primary: autoloaded.inverse_primary
    property alias inverse_surface: autoloaded.inverse_surface
    property alias on_background: autoloaded.on_background
    property alias on_error: autoloaded.on_error
    property alias on_error_container: autoloaded.on_error_container
    property alias on_primary: autoloaded.on_primary
    property alias on_primary_container: autoloaded.on_primary_container
    property alias on_primary_fixed: autoloaded.on_primary_fixed
    property alias on_primary_fixed_variant: autoloaded.on_primary_fixed_variant
    property alias on_secondary: autoloaded.on_secondary
    property alias on_secondary_container: autoloaded.on_secondary_container
    property alias on_secondary_fixed: autoloaded.on_secondary_fixed
    property alias on_secondary_fixed_variant: autoloaded.on_secondary_fixed_variant
    property alias on_surface: autoloaded.on_surface
    property alias on_surface_variant: autoloaded.on_surface_variant
    property alias on_tertiary: autoloaded.on_tertiary
    property alias on_tertiary_container: autoloaded.on_tertiary_container
    property alias on_tertiary_fixed: autoloaded.on_tertiary_fixed
    property alias on_tertiary_fixed_variant: autoloaded.on_tertiary_fixed_variant
    property alias outline: autoloaded.outline
    property alias outline_variant: autoloaded.outline_variant
    property alias primary: autoloaded.primary
    property alias primary_container: autoloaded.primary_container
    property alias primary_fixed: autoloaded.primary_fixed
    property alias primary_fixed_dim: autoloaded.primary_fixed_dim
    property alias scrim: autoloaded.scrim
    property alias secondary: autoloaded.secondary
    property alias secondary_container: autoloaded.secondary_container
    property alias secondary_fixed: autoloaded.secondary_fixed
    property alias secondary_fixed_dim: autoloaded.secondary_fixed_dim
    property alias shadow: autoloaded.shadow
    property alias source_color: autoloaded.source_color
    property alias surface: autoloaded.surface
    property alias surface_bright: autoloaded.surface_bright
    property alias surface_container: autoloaded.surface_container
    property alias surface_container_high: autoloaded.surface_container_high
    property alias surface_container_highest: autoloaded.surface_container_highest
    property alias surface_container_low: autoloaded.surface_container_low
    property alias surface_container_lowest: autoloaded.surface_container_lowest
    property alias surface_dim: autoloaded.surface_dim
    property alias surface_tint: autoloaded.surface_tint
    property alias surface_variant: autoloaded.surface_variant
    property alias tertiary: autoloaded.tertiary
    property alias tertiary_container: autoloaded.tertiary_container
    property alias tertiary_fixed: autoloaded.tertiary_fixed
    property alias tertiary_fixed_dim: autoloaded.tertiary_fixed_dim

    FileView {
        watchChanges: true
        path: `${Paths.config}/colors.json`

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: autoloaded

            property string background: '#101417'
            property string error: '#ffb4ab'
            property string error_container: '#93000a'
            property string inverse_on_surface: '#2d3135'
            property string inverse_primary: '#216487'
            property string inverse_surface: '#dfe3e7'
            property string on_background: '#dfe3e7'
            property string on_error: '#690005'
            property string on_error_container: '#ffdad6'
            property string on_primary: '#00344c'
            property string on_primary_container: '#c7e7ff'
            property string on_primary_fixed: '#001e2e'
            property string on_primary_fixed_variant: '#004c6c'
            property string on_secondary: '#21323e'
            property string on_secondary_container: '#d2e5f5'
            property string on_secondary_fixed: '#0b1d29'
            property string on_secondary_fixed_variant: '#374955'
            property string on_surface: '#dfe3e7'
            property string on_surface_variant: '#c1c7ce'
            property string on_tertiary: '#342b4b'
            property string on_tertiary_container: '#e8ddff'
            property string on_tertiary_fixed: '#1e1635'
            property string on_tertiary_fixed_variant: '#4a4263'
            property string outline: '#8b9198'
            property string outline_variant: '#41484d'
            property string primary: '#92cef5'
            property string primary_container: '#004c6c'
            property string primary_fixed: '#c7e7ff'
            property string primary_fixed_dim: '#92cef5'
            property string scrim: '#000000'
            property string secondary: '#b6c9d8'
            property string secondary_container: '#374955'
            property string secondary_fixed: '#d2e5f5'
            property string secondary_fixed_dim: '#b6c9d8'
            property string shadow: '#000000'
            property string source_color: '#455c6c'
            property string surface: '#101417'
            property string surface_bright: '#353a3d'
            property string surface_container: '#1c2024'
            property string surface_container_high: '#262a2e'
            property string surface_container_highest: '#313539'
            property string surface_container_low: '#181c20'
            property string surface_container_lowest: '#0a0f12'
            property string surface_dim: '#101417'
            property string surface_tint: '#92cef5'
            property string surface_variant: '#41484d'
            property string tertiary: '#ccc1e9'
            property string tertiary_container: '#4a4263'
            property string tertiary_fixed: '#e8ddff'
            property string tertiary_fixed_dim: '#ccc1e9'
        }
    }
}
