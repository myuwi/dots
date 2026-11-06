import Quickshell
import QtQuick
import qs

ListView {
    id: list

    readonly property int pageSize: 6
    readonly property int rowHeight: 36
    readonly property int maximumHeight: heightFor(pageSize)

    property var results: []
    property point lastPointer: Qt.point(-1, -1)

    signal activated(index: int)

    height: heightFor(Math.min(count, pageSize))
    visible: count > 0
    clip: true
    spacing: Tokens.spacing.sm
    boundsBehavior: Flickable.StopAtBounds
    highlightFollowsCurrentItem: false

    onResultsChanged: Qt.callLater(reset)

    function heightFor(rows: int): int {
        return rows * rowHeight + Math.max(rows - 1, 0) * spacing;
    }

    function move(amount: int): void {
        if (count > 0) {
            currentIndex = (currentIndex + amount + count) % count;
            positionViewAtIndex(currentIndex, ListView.Contain);
        }
    }

    function reset(): void {
        currentIndex = results.length > 0 ? 0 : -1;
        positionViewAtBeginning();
    }

    function followPointer(index: int, position: point): void {
        if (position !== lastPointer) {
            lastPointer = position;
            currentIndex = index;
        }
    }

    model: ScriptModel {
        values: list.results
        objectProp: "key"
    }

    delegate: ResultRow {
        width: ListView.view.width
        height: ListView.view.rowHeight
        selected: ListView.isCurrentItem
        onActivated: ListView.view.activated(index)
        onPointerMoved: (scenePosition) => ListView.view.followPointer(index, scenePosition)
    }
}
