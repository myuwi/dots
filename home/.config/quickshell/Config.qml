pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property var mainScreen:
        Quickshell.screens.find((screen) => screen.name === "DP-2") ?? Quickshell.screens[0]
}
