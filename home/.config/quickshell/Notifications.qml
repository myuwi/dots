import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
    NotificationServer {
        id: server
        keepOnReload: false
        imageSupported: true
        bodySupported: true
        actionsSupported: true

        onNotification: notification => {
            notification.tracked = true;
        }
    }

    PanelWindow {
        id: win

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "notifications"

        screen: Config.mainScreen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        visible: rep.count > 0

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        // One region per card, so the empty space beside and between cards does not eat clicks
        mask: Region {
            regions: {
                const out = [];
                for (let i = 0; i < rep.count; i++) {
                    const wrapper = rep.itemAt(i);
                    if (wrapper) {
                        out.push(wrapper.maskRegion);
                    }
                }
                return out;
            }
        }

        ColumnLayout {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: Tokens.spacing.lg
            anchors.rightMargin: Tokens.spacing.lg
            spacing: Tokens.spacing.md

            Repeater {
                id: rep
                model: server.trackedNotifications

                delegate: Item {
                    id: wrapper
                    required property var modelData

                    readonly property Region maskRegion: Region {
                        item: wrapper
                        radius: Tokens.rounding.md
                    }

                    property bool open: false
                    property real appearanceScale: open ? 1 : 0.96
                    property real swipeOffset: 0
                    property real swipeStartOffset: 0

                    Layout.alignment: Qt.AlignRight
                    implicitWidth: card.implicitWidth
                    implicitHeight: card.implicitHeight

                    opacity: open ? 1 : 0
                    // Scale around the card's edge before moving it with the swipe.
                    transform: [
                        Scale {
                            origin.x: wrapper.swipeOffset < 0 ? 0 : wrapper.width
                            origin.y: wrapper.height / 2
                            xScale: wrapper.appearanceScale
                            yScale: wrapper.appearanceScale
                        },
                        Translate { x: wrapper.swipeOffset }
                    ]

                    Behavior on opacity {
                        NumberAnimation { duration: Tokens.duration.md; easing.type: Tokens.easing.standard }
                    }
                    Behavior on appearanceScale {
                        NumberAnimation { duration: Tokens.duration.md; easing.type: Tokens.easing.standard }
                    }

                    NumberAnimation {
                        id: swipeSettle
                        target: wrapper
                        property: "swipeOffset"
                        duration: Tokens.duration.md
                        easing.type: Tokens.easing.standard
                    }

                    Component.onCompleted: wrapper.open = true

                    function close(byUser: bool): void {
                        if (!wrapper.open)
                            return;
                        wrapper.open = false;
                        closeTimer.byUser = byUser;
                        closeTimer.start();
                    }

                    function settleSwipe(target: real): void {
                        swipeSettle.from = swipeOffset;
                        swipeSettle.to = target;
                        swipeSettle.start();
                    }

                    NotificationItem {
                        id: card
                        anchors.right: parent.right
                        notification: wrapper.modelData
                        onCloseRequested: byUser => wrapper.close(byUser)
                    }

                    DragHandler {
                        parent: card
                        target: null
                        acceptedButtons: Qt.LeftButton
                        xAxis.enabled: true
                        yAxis.enabled: false

                        onActiveTranslationChanged: {
                            if (active)
                                wrapper.swipeOffset = wrapper.swipeStartOffset + activeTranslation.x;
                        }
                        onActiveChanged: {
                            if (active) {
                                swipeSettle.stop();
                                wrapper.swipeStartOffset = wrapper.swipeOffset;
                                return;
                            }
                            if (Math.abs(wrapper.swipeOffset) >= card.width * 0.3) {
                                wrapper.settleSwipe(Math.sign(wrapper.swipeOffset) * Math.max(Math.abs(wrapper.swipeOffset), card.width));
                                wrapper.close(true);
                            } else {
                                wrapper.settleSwipe(0);
                            }
                        }
                    }

                    Timer {
                        id: closeTimer
                        property bool byUser: false
                        interval: Tokens.duration.md
                        onTriggered: closeTimer.byUser ? wrapper.modelData.dismiss() : wrapper.modelData.expire()
                    }
                }
            }
        }
    }
}
