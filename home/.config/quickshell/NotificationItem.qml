import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property Notification notification

    signal closeRequested(bool byUser)

    readonly property int pad: 20
    readonly property int padY: 20
    readonly property int imageSize: 52
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
    implicitHeight: layout.implicitHeight + padY * 2

    color: Theme.bg
    radius: 8
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
        anchors.topMargin: root.padY
        anchors.bottomMargin: root.padY
        anchors.rightMargin: root.pad
        spacing: 12

        // Cover art, cropped to a rounded square.
        ClippingRectangle {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: root.imageSize
            Layout.preferredHeight: root.imageSize
            radius: 8
            color: "transparent"
            visible: root.hasImage

            Image {
                anchors.fill: parent
                source: root.notification.image
                sourceSize.width: root.imageSize * 2
                sourceSize.height: root.imageSize * 2
                fillMode: Image.PreserveAspectCrop
            }
        }

        ColumnLayout {
            spacing: 12
            Layout.fillWidth: true
            Layout.minimumWidth: 212
            Layout.maximumWidth: 320

            ColumnLayout {
                spacing: 0
                Layout.fillWidth: true

                RowLayout {
                    spacing: 6
                    Layout.fillWidth: true
                    Layout.bottomMargin: 4

                    Image {
                        source:
                            root.notification.appIcon !== ""
                                ? Quickshell.iconPath(root.notification.appIcon)
                                : ""
                        visible: root.notification.appIcon !== ""
                        sourceSize.width: 16
                        sourceSize.height: 16
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                    }

                    Text {
                        text: root.notification.appName
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.weight: Theme.fontWeight
                        font.pixelSize: 10
                        lineHeight: 16
                        lineHeightMode: Text.FixedHeight
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                Text {
                    text: root.notification.summary
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.weight: Font.Bold
                    font.pixelSize: 11
                    lineHeight: 16
                    lineHeightMode: Text.FixedHeight
                    wrapMode: Text.Wrap
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: root.notification.body
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.weight: Theme.fontWeight
                    font.pixelSize: 11
                    lineHeight: 16
                    lineHeightMode: Text.FixedHeight
                    visible: text !== ""
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    Layout.fillWidth: true
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
                            anchors.centerIn: parent
                            width: parent.width - 16
                            text: parent.modelData.text
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.weight: Theme.fontWeight
                            font.pixelSize: 11
                            lineHeight: 16
                            lineHeightMode: Text.FixedHeight
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
}
