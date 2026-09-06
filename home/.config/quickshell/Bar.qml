import Quickshell
import QtQuick

PanelWindow {
    id: bar

    screen: Config.mainScreen
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32

    // Absorb half of mango's gappov.
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: implicitHeight - 4

    // Tags for this bar's monitor, streamed from the compositor.
    ListModel {
        id: tagsModel
    }

    readonly property var monitorTags: Mango.tagsForMonitor(screen?.name ?? "")
    onMonitorTagsChanged: updateTags(monitorTags)

    function updateTags(tags) {
        let lastVisibleTag = 0;
        for (const tag of tags) {
            if (tag.client_count > 0 || tag.is_active) {
                lastVisibleTag = Math.max(lastVisibleTag, tag.index);
            }
        }

        const visibleTags = tags.filter(tag => tag.index <= lastVisibleTag);

        for (let i = 0; i < visibleTags.length; i++) {
            const tag = visibleTags[i];
            const roles = {
                tagIndex: tag.index,
                active: tag.is_active,
                urgent: tag.is_urgent
            };

            if (i < tagsModel.count) {
                tagsModel.set(i, roles);
            } else {
                tagsModel.append(roles);
            }
        }

        if (tagsModel.count > visibleTags.length) {
            tagsModel.remove(visibleTags.length, tagsModel.count - visibleTags.length);
        }
    }

    Component.onCompleted: updateTags(monitorTags)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Item {
        id: tagArea

        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: tagRow.implicitWidth

        Row {
            id: tagRow

            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            Repeater {
                model: tagsModel

                delegate: Rectangle {
                    required property bool active
                    required property bool urgent

                    anchors.verticalCenter: parent.verticalCenter
                    width: active ? 26 : 6
                    height: active ? 8 : 6
                    radius: height / 2
                    color: urgent ? Theme.urgent : active ? Theme.text : Theme.muted

                    Behavior on width {
                        NumberAnimation {
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on height {
                        NumberAnimation {
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton

            onWheel: wheel => {
                if (wheel.angleDelta.y !== 0) {
                    Mango.cycleTag(bar.screen?.name ?? "", wheel.angleDelta.y > 0 ? 1 : -1);
                    wheel.accepted = true;
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        color: Theme.text

        text: Qt.formatDateTime(clock.date, "hh:mm")
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        Systray {
            anchors.verticalCenter: parent.verticalCenter
            hostWindow: bar
        }

        Battery {
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
