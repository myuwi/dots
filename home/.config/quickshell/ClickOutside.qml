import Quickshell
import QtQuick

Scope {
    id: clickOutside

    property bool active: false

    signal clicked()

    onActiveChanged: OutsideClicks.setWatching(clickOutside, active)
    Component.onCompleted: OutsideClicks.setWatching(clickOutside, active)
    Component.onDestruction: OutsideClicks.setWatching(clickOutside, false)

    Connections {
        target: OutsideClicks
        enabled: clickOutside.active

        function onClicked(): void {
            clickOutside.clicked();
        }
    }
}
