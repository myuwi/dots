import Quickshell
import QtQuick

Scope {
    id: clickOutside

    required property string namespace
    property bool active: false

    signal clicked()

    Connections {
        target: Mango
        enabled: clickOutside.active

        function onPointerPressed(press: var): void {
            if (press.layer?.name !== clickOutside.namespace) {
                clickOutside.clicked();
            }
        }
    }
}
