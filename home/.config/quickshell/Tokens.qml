pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property int unit: 4

    readonly property QtObject spacing: QtObject {
        readonly property int xs: root.unit
        readonly property int sm: root.unit * 1.5
        readonly property int md: root.unit * 2
        readonly property int lg: root.unit * 3
        readonly property int xl: root.unit * 4
        readonly property int xxl: root.unit * 5
    }

    readonly property QtObject duration: QtObject {
        readonly property int md: 160
    }

    readonly property QtObject easing: QtObject {
        readonly property int standard: Easing.OutCubic
    }

    readonly property QtObject rounding: QtObject {
        readonly property int sm: 4
        readonly property int md: 8
        readonly property int full: 9999
    }

    readonly property QtObject icon: QtObject {
        readonly property int xs: 12
        readonly property int sm: 16
        readonly property int md: 18
    }

    readonly property QtObject font: QtObject {
        readonly property font caption: Qt.font({
            family: Theme.fontFamily,
            pixelSize: 10,
            weight: Theme.fontWeight,
        })
        readonly property font body: Qt.font({
            family: Theme.fontFamily,
            pixelSize: 11,
            weight: Theme.fontWeight,
        })
        readonly property font title: Qt.font({
            family: Theme.fontFamily,
            pixelSize: 11,
            weight: Font.Bold,
        })
        readonly property font display: Qt.font({
            family: Theme.fontFamily,
            pixelSize: 12,
            weight: Theme.fontWeight,
        })
    }
}
