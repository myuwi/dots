import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property Notification notification

    signal closeRequested(bool byUser)

    readonly property int pad: Tokens.spacing.xxl
    readonly property int imageSize: 68
    readonly property int textMinWidth: 216
    readonly property int textMaxWidth: 320
    readonly property bool hasImage: notification.image !== ""
    readonly property var visibleActions: {
        const actions = [];
        for (const action of notification.actions) {
            if (action.identifier !== "default") {
                actions.push(action);
            }
        }
        return actions;
    }

    implicitWidth: layout.implicitWidth + pad * 2
    implicitHeight: layout.implicitHeight + pad * 2

    color: Theme.bg
    radius: Tokens.rounding.md
    border.width: 1
    border.color: RosePine.overlay

    function activateDefault(): void {
        for (const action of notification.actions) {
            if (action.identifier === "default") {
                action.invoke();
                return;
            }
        }
    }

    // Auto-dismiss (expireTimeout is ms; <=0 means unset/never, so fall back).
    Timer {
        interval: root.notification.expireTimeout > 0 ? root.notification.expireTimeout : 5000
        running: !hoverHandler.hovered
        onTriggered: root.closeRequested(false)
    }

    HoverHandler {
        id: hoverHandler
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (event) => {
            if (event.button === Qt.LeftButton) {
                root.activateDefault();
                root.closeRequested(true);
            } else if (event.button === Qt.RightButton) {
                root.closeRequested(true);
            }
        }
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.leftMargin: root.pad
        anchors.topMargin: root.pad
        anchors.bottomMargin: root.pad
        anchors.rightMargin: root.pad
        spacing: Tokens.spacing.lg

        // Cover art, cropped to a rounded square.
        ClippingRectangle {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: root.imageSize
            Layout.preferredHeight: root.imageSize
            radius: Tokens.rounding.md
            color: "transparent"
            visible: root.hasImage

            Image {
                anchors.fill: parent
                source: root.notification.image
                sourceSize.width: root.imageSize
                sourceSize.height: root.imageSize
                fillMode: Image.PreserveAspectCrop
            }
        }

        ColumnLayout {
            spacing: Tokens.spacing.lg
            Layout.fillWidth: true
            Layout.minimumWidth: root.textMinWidth
            Layout.maximumWidth: root.textMaxWidth

            ColumnLayout {
                spacing: 0
                Layout.fillWidth: true

                RowLayout {
                    spacing: Tokens.spacing.sm
                    Layout.fillWidth: true
                    Layout.bottomMargin: Tokens.spacing.xs

                    IconImage {
                        source: Quickshell.iconPath(root.notification.appIcon, true)
                        visible: status === Image.Ready
                        Layout.preferredWidth: Tokens.icon.sm
                        Layout.preferredHeight: Tokens.icon.sm
                    }

                    Label {
                        font: Tokens.font.caption
                        text: root.notification.appName
                        Layout.fillWidth: true
                    }
                }

                Label {
                    text: root.notification.summary
                    font: Tokens.font.title
                    maximumLineCount: 1
                    Layout.fillWidth: true
                }

                Label {
                    text: root.notification.body
                    visible: text !== ""
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.sm
                visible: actionRepeater.count > 0

                Repeater {
                    id: actionRepeater

                    model: root.visibleActions

                    delegate: Rectangle {
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.preferredHeight: Tokens.spacing.md * 2 + actionLabel.leading
                        radius: Tokens.rounding.md
                        color: actionMouseArea.containsMouse ? Theme.itemHovered : Theme.surface

                        Label {
                            id: actionLabel

                            anchors.centerIn: parent
                            width: parent.width - Tokens.spacing.md * 2
                            text: parent.modelData.text
                            horizontalAlignment: Text.AlignHCenter
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
}
