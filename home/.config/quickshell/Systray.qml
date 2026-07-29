import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls as Controls

Row {
    id: root

    required property var hostWindow

    spacing: 8

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayItem

            required property var modelData

            width: 18
            height: 18

            function showMenu(): void {
                const pos = trayItem.mapToItem(root.hostWindow.contentItem, trayItem.width, trayItem.height);
                modelData.display(root.hostWindow, pos.x, pos.y);
            }

            IconImage {
                anchors.fill: parent
                source: trayItem.modelData.icon
            }

            MouseArea {
                id: mouseArea

                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                hoverEnabled: true

                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton) {
                        if (trayItem.modelData.hasMenu)
                            trayItem.showMenu();
                    } else if (mouse.button === Qt.MiddleButton) {
                        trayItem.modelData.secondaryActivate();
                    } else if (trayItem.modelData.onlyMenu && trayItem.modelData.hasMenu) {
                        trayItem.showMenu();
                    } else {
                        trayItem.modelData.activate();
                    }
                }

                onWheel: wheel => {
                    if (wheel.angleDelta.y !== 0) {
                        trayItem.modelData.scroll(wheel.angleDelta.y, false);
                    }
                }
            }

            Controls.ToolTip.visible: mouseArea.containsMouse && (modelData.tooltipTitle !== "" || modelData.title !== "")
            Controls.ToolTip.text: modelData.tooltipTitle || modelData.title
            Controls.ToolTip.delay: 2000
        }
    }
}
