import Quickshell
import Quickshell.Io
import QtQuick

FileView {
    id: history

    path: Quickshell.statePath("launcher-history.json")

    onAdapterUpdated: writeAdapter()

    function launchCount(key: string): int {
        return data.launchCounts[key] ?? 0;
    }

    function recordLaunch(key: string): void {
        data.launchCounts = Object.assign({}, data.launchCounts, { [key]: launchCount(key) + 1 });
    }

    adapter: JsonAdapter {
        id: data

        property var launchCounts: ({})
    }
}
