import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs

Rectangle {
    id: row

    required property var modelData
    required property int index
    property bool selected: false

    signal activated()
    signal pointerMoved(point scenePosition)

    radius: Tokens.rounding.sm
    color: selected ? Theme.itemSelected : "transparent"
    border.width: 1
    border.color: selected ? Theme.itemSelectedBorder : "transparent"

    RowLayout {
        id: content

        anchors.fill: parent
        anchors.leftMargin: Tokens.spacing.md
        anchors.rightMargin: Tokens.spacing.md
        spacing: Tokens.spacing.lg

        IconImage {
            Layout.preferredWidth: Tokens.icon.lg
            Layout.preferredHeight: Tokens.icon.lg
            source: Quickshell.iconPath(
                row.modelData.icon || "application-x-executable",
                "application-x-executable",
            )
        }

        Label {
            Layout.maximumWidth: content.width * 0.5
            text: row.modelData.title
        }

        Label {
            Layout.fillWidth: true
            text: row.modelData.subtitle
            color: Theme.muted
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.PointingHandCursor
        onClicked: row.activated()
        onPositionChanged: (mouse) => row.pointerMoved(mapToItem(null, mouse.x, mouse.y))
    }
}
