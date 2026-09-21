import Quickshell
import QtQuick

Text {
    property int size: Tokens.icon.md

    color: Theme.text
    font.family: Theme.iconFamily
    font.pixelSize: size
    textFormat: Text.PlainText
    renderType: Text.NativeRendering
}
