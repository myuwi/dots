pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: outsideClicks

    property var watchers: []
    readonly property bool watched: watchers.length > 0

    signal clicked()

    function report(): void {
        clicked();
    }

    function setWatching(watcher: var, watching: bool): void {
        const others = watchers.filter((other) => other !== watcher);
        watchers = watching ? [...others, watcher] : others;
    }
}
