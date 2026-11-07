import Quickshell
import Quickshell.Wayland
import QtQuick

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        required property var modelData

        WlrLayershell.layer: WlrLayer.Bottom
        WlrLayershell.namespace: "desktop"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        screen: modelData
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        visible: OutsideClicks.watched

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        OutsideClickArea {}
    }
}
