import Quickshell
import QtQuick
import QtQuick.Controls.Basic
import qs

Item {
    id: list

    readonly property int pageSize: 6
    readonly property int rowHeight: 36
    readonly property int maximumHeight: heightFor(pageSize)
    readonly property alias currentIndex: view.currentIndex

    property var results: []
    property point lastPointer: Qt.point(-1, -1)

    signal activated(index: int)

    height: heightFor(Math.min(view.count, pageSize))
    visible: view.count > 0

    onResultsChanged: Qt.callLater(reset)

    function heightFor(rows: int): int {
        return rows * rowHeight + Math.max(rows - 1, 0) * view.spacing;
    }

    function move(amount: int): void {
        if (view.count > 0) {
            view.currentIndex = (view.currentIndex + amount + view.count) % view.count;
            view.positionViewAtIndex(view.currentIndex, ListView.Contain);
        }
    }

    function reset(): void {
        view.currentIndex = results.length > 0 ? 0 : -1;
        view.positionViewAtBeginning();
    }

    function followPointer(index: int, position: point): void {
        if (position !== lastPointer) {
            lastPointer = position;
            view.currentIndex = index;
        }
    }

    ListView {
        id: view

        anchors.fill: parent
        clip: true
        spacing: Tokens.spacing.sm
        boundsBehavior: Flickable.StopAtBounds
        highlightFollowsCurrentItem: false

        model: ScriptModel {
            values: list.results
            objectProp: "key"
        }

        delegate: ResultRow {
            width: view.width
            height: list.rowHeight
            selected: ListView.isCurrentItem
            onActivated: list.activated(index)
            onPointerMoved: (scenePosition) => list.followPointer(index, scenePosition)
        }

        ScrollBar.vertical: ScrollBar {
            parent: list
            anchors.left: view.right
            anchors.leftMargin: Tokens.spacing.xs
            anchors.top: view.top
            anchors.bottom: view.bottom
            implicitWidth: Tokens.unit
            padding: 0
            visible: size < 1

            contentItem: Rectangle {
                radius: Tokens.rounding.full
                color: Theme.scrollbar
            }
        }
    }
}
