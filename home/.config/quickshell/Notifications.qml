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

        screen: Config.mainScreen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        visible: rep.count > 0

        anchors {
            bottom: true
            right: true
        }
        margins {
            bottom: 10
            right: 10
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

                delegate: NotificationItem {
                    required property var modelData
                    notification: modelData
                }
            }
        }
    }
}
