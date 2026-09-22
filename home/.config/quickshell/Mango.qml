pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: mango

    component Watch: Process {
        id: watcher

        required property string stream
        signal received(payload: var)

        command: ["mmsg", "watch", stream]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                try {
                    watcher.received(JSON.parse(data));
                } catch (error) {
                    console.warn(`${watcher.stream} parse error:`, error, data);
                }
            }
        }
    }

    property var allClients: []
    property var allTags: []
    property var focusHistory: []
    property int focusedClientId: -1

    readonly property var clientsByFocus: {
        const ordered = [];

        for (const clientId of focusHistory) {
            const client = allClients.find((candidate) => candidate.id === clientId);
            if (client) {
                ordered.push(client);
            }
        }

        // Until every client has appeared in the focus history, retain Mango's
        // tiling order as a stable fallback.
        for (const client of allClients) {
            if (!ordered.some((candidate) => candidate.id === client.id)) {
                ordered.push(client);
            }
        }

        return ordered;
    }

    function updateClients(clients): void {
        allClients = clients;
        focusHistory = focusHistory.filter(
            (clientId) =>
                clientId === focusedClientId || clients.some((client) => client.id === clientId),
        );
    }

    function updateFocusedClient(client): void {
        const focusedId = client?.id ?? -1;
        focusedClientId = focusedId;

        if (focusedId > 0) {
            focusHistory = [
                focusedId,
                ...focusHistory.filter((clientId) => clientId !== focusedId),
            ];
        }
    }

    function tagsForMonitor(monitorName: string): var {
        return allTags.find((entry) => entry.monitor === monitorName)?.tags ?? [];
    }

    function clientIsVisible(client): bool {
        const isVisible =
            client.is_global ||
            tagsForMonitor(client.monitor).some(
                (tag) => tag.is_active && client.tags.includes(tag.index),
            );

        return (
            isVisible && !client.is_minimized && !client.is_scratchpad && !client.is_namedscratchpad
        );
    }

    function focusClient(clientId: int): void {
        if (clientId > 0) {
            Quickshell.execDetached(["mmsg", "dispatch", "focusid", `client,${clientId}`]);
        }
    }

    function viewTag(monitorName: string, tagIndex: int): void {
        if (monitorName !== "" && tagIndex > 0) {
            Quickshell.execDetached([
                "mmsg",
                "dispatch",
                `viewcrossmon,${tagIndex},${monitorName}`,
            ]);
        }
    }

    function cycleTag(monitorName: string, amount: int): void {
        const tags = tagsForMonitor(monitorName);
        if (amount === 0 || tags.length === 0) {
            return;
        }

        const currentIndex = tags.findIndex((tag) => tag.is_active);
        if (currentIndex < 0) {
            return;
        }

        const targetIndex = (currentIndex + amount + tags.length) % tags.length;
        viewTag(monitorName, tags[targetIndex].index);
    }

    Watch {
        stream: "all-clients"
        onReceived: (payload) => mango.updateClients(payload.clients ?? [])
    }

    Watch {
        stream: "focusing-client"
        onReceived: (payload) => mango.updateFocusedClient(payload)
    }

    Watch {
        stream: "all-tags"
        onReceived: (payload) => (mango.allTags = payload.all_tags ?? [])
    }
}
