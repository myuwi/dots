import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

Scope {
    id: switcher

    property var visibleClients: []
    property int selectedIndex: -1
    property bool shown: false
    readonly property var desktopApplications: DesktopEntries.applications.values

    function cycle(amount: int): void {
        if (visibleClients.length === 0 || amount === 0) {
            return;
        }

        selectedIndex = (selectedIndex + amount + visibleClients.length) % visibleClients.length;
        if (shown) {
            Qt.callLater(ensureSelectedVisible);
        }
    }

    function ensureSelectedVisible(): void {
        if (!shown || selectedIndex < 0) {
            return;
        }

        const card = cardRepeater.itemAt(selectedIndex);
        if (card) {
            viewport.positionViewAtChild(card, Flickable.Contain);
        }
    }

    function show(direction: int): void {
        if (shown) {
            cycle(direction);
            return;
        }

        visibleClients = Mango.clientsByFocus.filter((client) => Mango.clientIsVisible(client));

        if (visibleClients.length === 0) {
            return;
        }

        if (visibleClients.length === 1) {
            activateClientAtIndex(0);
            return;
        }

        selectedIndex = 0;

        let cycleAmount = direction;
        if (Mango.focusedClientId < 0 && cycleAmount > 0) {
            cycleAmount--;
        }
        cycle(cycleAmount);

        viewport.contentX = 0;
        shown = true;
        Qt.callLater(() => {
            keyHandler.forceActiveFocus();
            ensureSelectedVisible();
        });
    }

    function hide(): void {
        shown = false;
        visibleClients = [];
        selectedIndex = -1;
    }

    function cancel(): void {
        if (shown) {
            hide();
        }
    }

    function commit(): void {
        if (shown && selectedIndex >= 0) {
            activateClientAtIndex(selectedIndex);
        }
    }

    function activateClientAtIndex(index: int): void {
        const client = visibleClients[index];
        if (!client) {
            return;
        }

        Mango.focusClient(client.id);
        hide();
    }

    IpcHandler {
        target: "windowSwitcher"

        function show(direction: int): void {
            switcher.show(direction);
        }

        function commit(): void {
            switcher.commit();
        }

        function cancel(): void {
            switcher.cancel();
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            required property var modelData

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "window-switcher-backdrop"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            visible: switcher.shown && modelData !== Config.mainScreen

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                onClicked: switcher.cancel()
            }
        }
    }

    PanelWindow {
        id: window

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "window-switcher"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        screen: Config.mainScreen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        focusable: true
        visible: switcher.shown

        ShortcutInhibitor {
            window: window
            enabled: switcher.shown
        }

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Item {
            id: keyHandler

            anchors.fill: parent
            focus: switcher.shown

            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Tab) {
                    switcher.cycle(event.modifiers & Qt.ShiftModifier ? -1 : 1);
                    event.accepted = true;
                } else if (event.key === Qt.Key_Backtab) {
                    switcher.cycle(-1);
                    event.accepted = true;
                } else if (event.key === Qt.Key_Escape) {
                    switcher.cancel();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    switcher.commit();
                    event.accepted = true;
                }
            }

            Keys.onReleased: (event) => {
                if (
                    event.key === Qt.Key_Meta ||
                    event.key === Qt.Key_Super_L ||
                    event.key === Qt.Key_Super_R
                ) {
                    switcher.commit();
                    event.accepted = true;
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onClicked: switcher.cancel()
        }

        Rectangle {
            id: popup

            anchors.centerIn: parent
            width: Math.min(
                cards.implicitWidth + Tokens.spacing.lg * 2,
                window.width - Tokens.spacing.lg * 4,
            )
            height: cards.implicitHeight + Tokens.spacing.lg * 2

            color: Theme.bg
            radius: Tokens.rounding.md
            border.width: 1
            border.color: RosePine.overlay

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
            }

            Flickable {
                id: viewport

                anchors.fill: parent
                anchors.margins: Tokens.spacing.lg
                contentWidth: cards.implicitWidth
                contentHeight: cards.implicitHeight
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                Row {
                    id: cards

                    spacing: Tokens.spacing.sm

                    Repeater {
                        id: cardRepeater

                        model: switcher.visibleClients

                        delegate: Rectangle {
                            id: card

                            required property var modelData
                            required property int index

                            readonly property bool selected: index === switcher.selectedIndex
                            readonly property var desktopEntry: {
                                // Make the method lookup reactive to desktop-entry model changes.
                                switcher.desktopApplications;
                                return DesktopEntries.heuristicLookup(modelData.appid);
                            }
                            readonly property string iconName:
                                desktopEntry?.icon || modelData.appid || "application-x-executable"

                            width: 108
                            height: 126
                            radius: Tokens.rounding.md
                            color: mouseArea.containsMouse
                                ? Theme.itemHovered
                                : selected
                                  ? Theme.itemSelected
                                  : "transparent"
                            border.width: 1
                            border.color: mouseArea.containsMouse
                                ? Theme.itemHoveredBorder
                                : selected
                                  ? Theme.itemSelectedBorder
                                  : "transparent"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 100
                                }
                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 100
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: Tokens.spacing.sm

                                Item {
                                    width: 84
                                    height: 84

                                    IconImage {
                                        anchors.centerIn: parent
                                        width: 60
                                        height: 60
                                        source: Quickshell.iconPath(
                                            card.iconName,
                                            "application-x-executable",
                                        )
                                    }
                                }

                                Label {
                                    width: 84
                                    text: card.modelData.title
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            MouseArea {
                                id: mouseArea

                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton
                                cursorShape: Qt.PointingHandCursor
                                onClicked: switcher.activateClientAtIndex(card.index)
                            }
                        }
                    }
                }
            }
        }
    }
}
