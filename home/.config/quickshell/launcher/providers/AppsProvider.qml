import Quickshell
import Quickshell.Io
import QtQuick
import qs
import qs.launcher

Provider {
    id: provider

    name: "apps"

    readonly property var items: DesktopEntries.applications.values
        .filter((entry) => !entry.noDisplay)
        .map((entry) => ({
            key: `apps:${entry.id}`,
            title: entry.name,
            subtitle: entry.comment,
            icon: entry.icon,
            keywords: [entry.genericName, ...entry.keywords].filter((keyword) => keyword !== ""),
            run: () => provider.launch(entry),
        }))

    function launch(entry: var): void {
        Quickshell.execDetached({
            command: entry.runInTerminal ? [...Config.terminal, ...entry.command] : entry.command,
            workingDirectory: entry.workingDirectory,
        });
    }

    function search(query: string, emit: var): void {
        emit(items);
    }
}
