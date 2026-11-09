import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs
import qs.launcher.providers

Scope {
    id: launcher

    property bool shown: false
    readonly property string activeTags: JSON.stringify(
        Mango.allTags.map((entry) => [
            entry.monitor,
            entry.tags.filter((tag) => tag.is_active).map((tag) => tag.index),
        ]),
    )

    onActiveTagsChanged: close()

    function open(): void {
        input.text = "";
        engine.search();
        shown = true;
        Qt.callLater(() => input.forceActiveFocus());
    }

    function close(): void {
        shown = false;
    }

    function activate(index: int): void {
        const item = engine.results[index];
        if (item) {
            close();
            engine.launch(item);
        }
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            if (launcher.shown) {
                launcher.close();
            } else {
                launcher.open();
            }
        }
    }

    ClickOutside {
        namespace: window.WlrLayershell.namespace
        active: launcher.shown
        onClicked: launcher.close()
    }

    SearchEngine {
        id: engine

        query: input.text
        providers: [
            AppsProvider {}
        ]
    }

    PanelWindow {
        id: window

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "launcher"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        screen: Config.mainScreen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        focusable: true
        visible: launcher.shown
        mask: Region {
            item: popup
        }

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Rectangle {
            id: popup

            readonly property int inputHeight: 32
            readonly property int maximumHeight:
                inputHeight + list.maximumHeight + Tokens.spacing.lg * 2 + content.spacing

            x: Math.round((window.width - width) / 2)
            y: Math.round((window.height - maximumHeight) / 2)
            width: 512
            height: content.implicitHeight + Tokens.spacing.lg * 2

            color: Theme.bg
            radius: Tokens.rounding.md
            border.width: 1
            border.color: RosePine.overlay

            Window.onActiveChanged: {
                if (!Window.active && window.visible) {
                    launcher.close();
                }
            }

            Column {
                id: content

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Tokens.spacing.lg
                spacing: Tokens.spacing.lg

                Item {
                    width: parent.width
                    height: popup.inputHeight

                    TextInput {
                        id: input

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Tokens.spacing.md
                        anchors.rightMargin: Tokens.spacing.md
                        clip: true
                        color: Theme.text
                        selectionColor: Theme.itemHovered
                        selectedTextColor: Theme.text
                        selectByMouse: true
                        font: Tokens.font.body
                        renderType: Text.NativeRendering

                        Keys.onPressed: (event) => {
                            if (event.key === Qt.Key_Down) {
                                list.move(1);
                            } else if (event.key === Qt.Key_Up) {
                                list.move(-1);
                            } else if (event.key === Qt.Key_Tab) {
                                list.move(event.modifiers & Qt.ShiftModifier ? -1 : 1);
                            } else if (event.key === Qt.Key_Backtab) {
                                list.move(-1);
                            } else if (event.key === Qt.Key_Escape) {
                                launcher.close();
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                launcher.activate(list.currentIndex);
                            } else {
                                return;
                            }
                            event.accepted = true;
                        }

                        Label {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            font: Tokens.font.body
                            text: "Search for apps..."
                            color: Theme.muted
                            visible: input.text === ""
                        }
                    }
                }

                ResultList {
                    id: list

                    width: parent.width
                    results: engine.results
                    onActivated: (index) => launcher.activate(index)
                }
            }
        }
    }
}
