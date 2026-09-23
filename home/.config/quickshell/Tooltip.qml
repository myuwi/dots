import Quickshell
import QtQuick

PopupWindow {
    id: root

    required property Item target
    property string text: ""
    property bool shown: false
    property int delay: 1000
    property int outerMargin: Tokens.spacing.xs

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.adjustment: PopupAdjustment.Slide

    implicitWidth: background.implicitWidth + outerMargin * 2
    implicitHeight: background.implicitHeight + outerMargin * 2
    color: "transparent"

    onShownChanged: {
        if (!shown) {
            showTimer.stop();
            visible = false;
        } else if (delay <= 0) {
            visible = true;
        } else {
            showTimer.restart();
        }
    }

    Timer {
        id: showTimer

        interval: root.delay
        onTriggered: {
            if (root.shown) root.visible = true;
        }
    }

    Rectangle {
        id: background

        anchors.fill: parent
        anchors.margins: root.outerMargin
        implicitWidth: label.implicitWidth + Tokens.spacing.md * 2
        implicitHeight: label.implicitHeight + Tokens.spacing.xs * 2
        color: Theme.surface
        radius: Tokens.rounding.sm
        border.width: 1
        border.color: RosePine.overlay

        Label {
            id: label

            anchors.centerIn: parent
            text: root.text
        }
    }
}
