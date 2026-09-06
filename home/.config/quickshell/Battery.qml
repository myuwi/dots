import Quickshell.Services.UPower
import QtQuick

Item {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property int percentage: Math.round(battery.percentage * 100)
    readonly property real chargeLevel: Math.max(0, Math.min(1, battery.percentage))
    readonly property bool charging:
        battery.state === UPowerDeviceState.Charging ||
        battery.state === UPowerDeviceState.FullyCharged ||
        battery.state === UPowerDeviceState.PendingCharge

    visible: battery.ready && battery.isLaptopBattery && battery.isPresent
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content

        spacing: 4

        Item {
            id: batteryIcon

            anchors.verticalCenter: parent.verticalCenter
            width: baseIcon.implicitWidth
            height: baseIcon.implicitHeight

            Text {
                id: baseIcon

                anchors.centerIn: parent
                color: Theme.muted

                text: Icons.batteryAndroidFull
                font.family: Theme.iconFamily
                font.pointSize: Theme.fontSize * 1.6
            }

            Item {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * root.chargeLevel
                clip: true

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.charging
                        ? Theme.success
                        : root.percentage <= 20 && UPower.onBattery
                          ? Theme.urgent
                          : Theme.text

                    text: Icons.batteryAndroidFull
                    font.family: Theme.iconFamily
                    font.pointSize: Theme.fontSize * 1.6
                }
            }

            Text {
                anchors.centerIn: parent
                visible: root.charging
                color: Theme.text

                text: Icons.bolt
                font.family: Theme.iconFamily
                font.pointSize: Theme.fontSize
                renderType: Text.NativeRendering
                font.variableAxes: ({
                    FILL: 1,
                })
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: root.percentage <= 20 && UPower.onBattery ? Theme.urgent : Theme.text
            text: `${root.percentage}%`
        }
    }

    Tooltip {
        target: root
        shown: hover.hovered
        text: `${UPowerDeviceState.toString(root.battery.state)} · ${root.percentage}%`
    }

    HoverHandler {
        id: hover
    }
}
