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
            bottom: true
            right: true
        }
        margins {
            bottom: 12
            right: 12
        }

        implicitWidth: list.implicitWidth
        implicitHeight: list.implicitHeight

        ColumnLayout {
            id: list
            anchors.fill: parent
            spacing: 8

            Repeater {
                id: rep
                model: server.trackedNotifications

                delegate: Item {
                    id: wrapper
                    required property var modelData

                    Layout.fillWidth: true
                    implicitWidth: card.implicitWidth
                    implicitHeight: card.implicitHeight

                    NotificationItem {
                        id: card
                        anchors.right: parent.right
                        notification: wrapper.modelData
                    }
                }
            }
        }
    }
}
