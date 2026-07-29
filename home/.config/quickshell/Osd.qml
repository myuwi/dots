import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
    id: osd

    property string icon: ""
    property string label: ""
    property string value: ""
    property real progress: -1 // 0..1, or <0 for no bar
    property bool shown: false

    // Pipewire emits the initial state as it settles on startup; ignore it so
    // the OSD only appears on a real user change.
    property bool settled: false
    Timer {
        interval: 800
        running: true
        onTriggered: osd.settled = true
    }

    function show(icon: string, label: string, value: string, progress: real): void {
        osd.icon = icon;
        osd.label = label;
        osd.value = value;
        osd.progress = progress;
        osd.shown = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: osd.shown = false
    }

    // --- Sources ---
    IpcHandler {
        target: "osd"

        function show(icon: string, label: string, value: string, progress: real): void {
            osd.show(Icons[icon] ?? "", label, value, progress);
        }
    }

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    // Required for the nodes' audio properties to stay live.
    PwObjectTracker {
        objects: [osd.sink, osd.source]
    }

    Connections {
        target: osd.sink?.audio ?? null
        function show() {
            const a = osd.sink.audio;
            const icon = a.muted ? Icons.noSound : a.volume <= 0 ? Icons.volumeMute : a.volume > 0.5 ? Icons.volumeHigh : Icons.volumeLow;
            osd.show(icon, a.muted ? "Muted" : "Volume", `${Math.round(a.volume * 100)}%`, a.volume);
        }
        function onVolumeChanged() {
            if (osd.settled) {
                show();
            }
        }
        function onMutedChanged() {
            if (osd.settled) {
                show();
            }
        }
    }

    Connections {
        target: osd.source?.audio ?? null
        function show() {
            const a = osd.source.audio;
            osd.show(a.muted ? Icons.micMuted : Icons.mic, a.muted ? "Microphone muted" : "Microphone", `${Math.round(a.volume * 100)}%`, a.volume);
        }
        function onVolumeChanged() {
            if (osd.settled) {
                show();
            }
        }
        function onMutedChanged() {
            if (osd.settled) {
                show();
            }
        }
    }

    // --- Surface ---
    PanelWindow {
        WlrLayershell.layer: WlrLayer.Overlay

        screen: Config.mainScreen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        visible: osd.shown

        anchors.bottom: true
        margins.bottom: 96

        implicitWidth: 280
        implicitHeight: card.implicitHeight

        Rectangle {
            id: card
            anchors.fill: parent

            implicitHeight: layout.implicitHeight + 32

            color: Theme.bg
            radius: 8
            border.width: 1
            border.color: RosePine.overlay

            ColumnLayout {
                id: layout
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                RowLayout {
                    Layout.fillWidth: true
                    visible: osd.icon !== "" || osd.label !== "" || osd.value !== ""
                    spacing: 8

                    Text {
                        text: osd.icon
                        visible: osd.icon !== ""
                        color: Theme.text
                        font.family: Theme.iconFamily
                        font.pointSize: Theme.fontSize * 1.6
                    }

                    Text {
                        text: osd.label
                        visible: osd.label !== ""
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.weight: Font.Bold
                        font.pointSize: Theme.fontSize
                        Layout.fillWidth: true
                    }

                    Text {
                        text: osd.value
                        visible: osd.value !== ""
                        color: Theme.muted
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize
                    }
                }

                Rectangle {
                    visible: osd.progress >= 0
                    Layout.fillWidth: true
                    implicitHeight: 6
                    radius: 3
                    color: RosePine.overlay

                    Rectangle {
                        width: parent.width * Math.min(osd.progress, 1)
                        height: parent.height
                        radius: 3
                        color: Theme.text
                    }
                }
            }
        }
    }
}
