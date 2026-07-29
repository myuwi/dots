import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property Notification notification

    readonly property int pad: 18
    readonly property var visibleActions: {
        const actions = [];
        for (const action of notification.actions) {
            if (action.identifier !== "default") {
                actions.push(action);
            }
        }
        return actions;
    }

    Layout.preferredWidth: 360
    implicitHeight: layout.implicitHeight + pad * 2

    color: Theme.bg
    radius: 8
    border.width: 1
    border.color: RosePine.overlay

    function invokeDefaultAction(): void {
        for (const action of notification.actions) {
            if (action.identifier === "default") {
                action.invoke();
                return;
            }
        }

        notification.dismiss();
    }

    // Auto-dismiss (expireTimeout is ms; <=0 means unset/never, so fall back).
    Timer {
        interval: root.notification.expireTimeout > 0 ? root.notification.expireTimeout : 5000
        running: !hoverHandler.hovered
        onTriggered: root.notification.expire()
    }

    HoverHandler {
        id: hoverHandler
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                root.invokeDefaultAction();
            } else if (event.button === Qt.RightButton) {
                root.notification.expire();
            }
        }
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: root.pad
        spacing: 12

        // App name
        RowLayout {
            spacing: 6

            Image {
                source: root.notification.appIcon !== "" ? Quickshell.iconPath(root.notification.appIcon) : ""
                visible: root.notification.appIcon !== ""
                sourceSize.width: 18
                sourceSize.height: 18
                Layout.preferredWidth: 18
                Layout.preferredHeight: 18
            }

            Text {
                text: root.notification.appName
                color: Theme.text
                font.family: Theme.fontFamily
                font.weight: Theme.fontWeight
                font.pointSize: Theme.fontSize
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // Image + summary/body
        RowLayout {
            spacing: 12

            Image {
                source: root.notification.image
                visible: root.notification.image !== ""
                sourceSize.width: 60
                sourceSize.height: 60
                fillMode: Image.PreserveAspectCrop
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                Layout.alignment: Qt.AlignTop
            }

            ColumnLayout {
                spacing: 3
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 6
                Layout.bottomMargin: 6

                Text {
                    text: root.notification.summary
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.weight: Font.Bold
                    font.pointSize: Theme.fontSize
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                Text {
                    text: root.notification.body
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.weight: Theme.fontWeight
                    font.pointSize: Theme.fontSize
                    visible: text !== ""
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: actionRepeater.count > 0

            Repeater {
                id: actionRepeater

                model: root.visibleActions

                delegate: Rectangle {
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: 28
                    radius: 8
                    color: actionMouseArea.containsMouse ? Theme.itemHovered : Theme.surface

                    Text {
                        anchors.fill: parent
                        anchors.margins: 8
                        text: parent.modelData.text
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.weight: Theme.fontWeight
                        font.pointSize: Theme.fontSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: actionMouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton
                        cursorShape: Qt.PointingHandCursor
                        onClicked: parent.modelData.invoke()
                    }
                }
            }
        }
    }
}
