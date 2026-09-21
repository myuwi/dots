import Quickshell
import QtQuick

Item {
    id: root

    property font font: Tokens.font.body
    property int leading: Math.ceil(metrics.height / Tokens.unit) * Tokens.unit

    property alias text: label.text
    property alias color: label.color
    property alias wrapMode: label.wrapMode
    property alias maximumLineCount: label.maximumLineCount
    property alias horizontalAlignment: label.horizontalAlignment
    property alias elide: label.elide

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    FontMetrics {
        id: metrics

        font: root.font
    }

    Text {
        id: label

        width: root.width
        y: (root.leading - metrics.height) / 2
        color: Theme.text
        font: root.font
        textFormat: Text.PlainText
        renderType: Text.NativeRendering
        lineHeight: root.leading
        lineHeightMode: Text.FixedHeight
        elide: Text.ElideRight
    }
}
