import Quickshell
import QtQuick

Scope {
    id: engine

    property list<Provider> providers
    property string query: ""
    property var results: []

    property int latestSearchId: 0
    property var candidates: ({})

    onQueryChanged: search()

    function search(): void {
        const searchId = ++latestSearchId;
        candidates = {};

        for (const provider of providers) {
            provider.search(query, (items) => {
                if (searchId === latestSearchId) {
                    candidates[provider.name] = items;
                    rank();
                }
            });
        }
    }

    function launch(item: var): void {
        history.recordLaunch(item.key);
        item.run();
    }

    function rank(): void {
        const text = query.trim().toLowerCase();
        const ranked = [];

        for (const items of Object.values(candidates)) {
            for (const item of items) {
                const matchRank = rankMatch(item, text);
                if (matchRank !== null) {
                    ranked.push({
                        item,
                        matchRank,
                        launchCount: history.launchCount(item.key),
                        title: item.title.toLowerCase(),
                    });
                }
            }
        }

        ranked.sort(
            (a, b) =>
                a.matchRank - b.matchRank ||
                b.launchCount - a.launchCount ||
                (a.title < b.title ? -1 : a.title > b.title ? 1 : 0),
        );
        results = ranked.map((entry) => entry.item);
    }

    function rankMatch(item: var, text: string): var {
        const title = item.title.toLowerCase();

        if (title.startsWith(text)) {
            return 0;
        }
        if (title.split(/[\s\-_.]+/).some((word) => word.startsWith(text))) {
            return 1;
        }
        if (title.includes(text)) {
            return 2;
        }
        if (containsInOrder(title, text)) {
            return 3;
        }

        const fields = [item.subtitle, ...item.keywords];
        return fields.some((field) => field.toLowerCase().includes(text)) ? 4 : null;
    }

    function containsInOrder(title: string, text: string): bool {
        let matched = 0;
        for (const character of title) {
            if (character === text[matched] && ++matched === text.length) {
                return true;
            }
        }
        return false;
    }

    History {
        id: history
    }
}
