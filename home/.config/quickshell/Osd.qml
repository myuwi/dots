import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
    id: osd

    property QtObject provider: null
    property bool shown: false

    readonly property var display: osd.provider?.display ?? null

    function present(provider: QtObject): void {
        osd.provider = provider;
        osd.shown = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: osd.shown = false
    }

    // --- Providers ---
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    // Required for the nodes' audio properties to stay live.
    PwObjectTracker {
        objects: [osd.sink, osd.source]
    }

    QtObject {
        id: volumeProvider

        readonly property var display: {
            const a = osd.sink?.audio;
            if (!a) return null;
            return {
                icon: a.muted
                    ? Icons.noSound
                    : a.volume <= 0
                      ? Icons.volumeMute
                      : a.volume > 0.5
                        ? Icons.volumeHigh
                        : Icons.volumeLow,
                label: a.muted ? "Muted" : "Volume",
                value: `${Math.round(a.volume * 100)}%`,
                progress: a.volume,
            };
        }
    }

    QtObject {
        id: microphoneProvider

        readonly property var display: {
            const a = osd.source?.audio;
            if (!a) return null;
            return {
                icon: a.muted ? Icons.micMuted : Icons.mic,
                label: a.muted ? "Microphone muted" : "Microphone",
                value: `${Math.round(a.volume * 100)}%`,
                progress: a.volume,
            };
        }
    }

    QtObject {
        id: customProvider

        property var display: null
    }

    IpcHandler {
        target: "osd"

        function volume(): void {
            osd.present(volumeProvider);
        }

        function microphone(): void {
            osd.present(microphoneProvider);
        }

        function show(icon: string, label: string, value: string, progress: real): void {
            customProvider.display = {
                icon: Icons[icon] ?? "",
                label: label,
                value: value,
                progress: progress,
            };
            osd.present(customProvider);
        }
    }

    // --- Surface ---
    PanelWindow {
        WlrLayershell.layer: WlrLayer.Overlay

        screen: Config.mainScreen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        visible: osd.shown && osd.display !== null

        anchors.bottom: true
        margins.bottom: 96

        implicitWidth: 280
        implicitHeight: card.implicitHeight

        Rectangle {
            id: card
            anchors.fill: parent

            implicitHeight: layout.implicitHeight + 32

            color: Theme.bg
            radius: Tokens.rounding.md
            border.width: 1
            border.color: RosePine.overlay

            ColumnLayout {
                id: layout
                anchors.fill: parent
                anchors.margins: Tokens.spacing.xl
                spacing: Tokens.spacing.lg

                RowLayout {
                    Layout.fillWidth: true
                    visible: Boolean(osd.display?.icon || osd.display?.label || osd.display?.value)
                    spacing: Tokens.spacing.md

                    Icon {
                        text: osd.display?.icon ?? ""
                        visible: text !== ""
                    }

                    Label {
                        text: osd.display?.label ?? ""
                        visible: text !== ""
                        font: Tokens.font.title
                        Layout.fillWidth: true
                    }

                    Label {
                        text: osd.display?.value ?? ""
                        visible: text !== ""
                        color: Theme.muted
                    }
                }

                Rectangle {
                    readonly property real progress: osd.display?.progress ?? -1

                    visible: progress >= 0
                    Layout.fillWidth: true
                    implicitHeight: 6
                    radius: 3
                    color: RosePine.overlay

                    Rectangle {
                        width: parent.width * Math.min(parent.progress, 1)
                        height: parent.height
                        radius: 3
                        color: Theme.text
                    }
                }
            }
        }
    }
}
