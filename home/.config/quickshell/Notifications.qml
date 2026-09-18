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
        mask: Region { item: list }

        ColumnLayout {
            id: list
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 12
            anchors.rightMargin: 12
            spacing: 8

            Repeater {
                id: rep
                model: server.trackedNotifications

                delegate: Item {
                    id: wrapper
                    required property var modelData

                    property bool open: false
                    property real appearanceScale: open ? 1 : 0.96
                    property real swipeOffset: 0
                    property real swipeStartOffset: 0

                    Layout.fillWidth: true
                    implicitWidth: card.implicitWidth
                    implicitHeight: card.implicitHeight

                    opacity: open ? 1 : 0
                    // Scale around the card's edge before moving it with the swipe.
                    transform: [
                        Scale {
                            origin.x: wrapper.swipeOffset < 0 ? card.x : card.x + card.width
                            origin.y: card.y + card.height / 2
                            xScale: wrapper.appearanceScale
                            yScale: wrapper.appearanceScale
                        },
                        Translate { x: wrapper.swipeOffset }
                    ]

                    Behavior on opacity {
                        NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                    }
                    Behavior on appearanceScale {
                        NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                    }

                    NumberAnimation {
                        id: swipeSettle
                        target: wrapper
                        property: "swipeOffset"
                        duration: 160
                        easing.type: Easing.OutCubic
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
                        interval: 160
                        onTriggered: closeTimer.byUser ? wrapper.modelData.dismiss() : wrapper.modelData.expire()
                    }
                }
            }
        }
    }
}
