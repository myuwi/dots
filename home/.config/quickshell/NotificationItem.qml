import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

Rectangle {
    id: root

    required property Notification notification

    signal closeRequested(bool byUser)

    readonly property int pad: 18
    readonly property int padY: 24
    readonly property int minWidth: 216
    readonly property int maxWidth: 360
    readonly property int rightInset: notification.image !== "" ? pad + 96 : pad
    readonly property int contentMaxWidth: maxWidth - pad - rightInset
    readonly property var visibleActions: {
        const actions = [];
        for (const action of notification.actions) {
            if (action.identifier !== "default") {
                actions.push(action);
            }
        }
        return actions;
    }

    implicitWidth: Math.max(minWidth, Math.min(layout.implicitWidth + pad + rightInset, maxWidth))
    implicitHeight: layout.implicitHeight + padY * 2

    color: Theme.bg
    radius: 8

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

    // Border below the cover art so the art can paint over it.
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: root.radius
        border.width: 1
        border.color: RosePine.overlay
    }

    // Floating cover art, faded into the card background.
    ClippingRectangle {
        anchors.fill: parent
        radius: root.radius
        color: "transparent"
        visible: root.notification.image !== ""

        Image {
            id: coverArt
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: -8
            anchors.bottomMargin: -8
            width: height
            sourceSize.width: 150
            sourceSize.height: 150
            source: root.notification.image
            fillMode: Image.PreserveAspectFit
            visible: false
        }

        Rectangle {
            id: coverMask
            anchors.fill: coverArt
            visible: false
            layer.enabled: true
            gradient: Gradient {
                orientation: Gradient.Horizontal
                // qmlformat off
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                GradientStop { position: 0.85; color: Qt.rgba(1, 1, 1, 1) }
                GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 1) }
                // qmlformat on
            }
        }

        MultiEffect {
            anchors.fill: coverArt
            source: coverArt
            maskEnabled: true
            maskSource: coverMask
            // Default threshold/spread is a near-hard cutoff; widen it across the full alpha range to get a smooth fade
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.leftMargin: root.pad
        anchors.topMargin: root.padY
        anchors.bottomMargin: root.padY
        anchors.rightMargin: root.rightInset
        spacing: 12

        ColumnLayout {
            spacing: 3
            Layout.fillWidth: true

            RowLayout {
                spacing: 6
                Layout.fillWidth: true
                Layout.bottomMargin: 3

                Image {
                    source:
                        root.notification.appIcon !== ""
                            ? Quickshell.iconPath(root.notification.appIcon)
                            : ""
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
                    font.pointSize: Theme.fontSizeSm
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            Text {
                text: root.notification.summary
                color: Theme.text
                font.family: Theme.fontFamily
                font.weight: Font.Bold
                font.pointSize: Theme.fontSize
                wrapMode: Text.Wrap
                Layout.maximumWidth: root.contentMaxWidth
            }

            Text {
                text: root.notification.body
                color: Theme.text
                font.family: Theme.fontFamily
                font.weight: Theme.fontWeight
                font.pointSize: Theme.fontSize
                visible: text !== ""
                wrapMode: Text.Wrap
                Layout.maximumWidth: root.contentMaxWidth
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
