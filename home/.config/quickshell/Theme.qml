pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property color bg: RosePine.base
    readonly property color surface: RosePine.surface
    readonly property color text: RosePine.text
    readonly property color subtle: RosePine.subtle
    readonly property color muted: RosePine.muted
    readonly property color accent: RosePine.rose
    readonly property color success: mix(RosePine.pine, RosePine.text, 0.25)
    readonly property color urgent: RosePine.love

    readonly property color itemSelected: withOpacity(muted, 0.15)
    readonly property color itemHovered: withOpacity(muted, 0.25)
    readonly property color itemSelectedBorder: withOpacity(muted, 0.2)
    readonly property color itemHoveredBorder: withOpacity(muted, 0.3)

    readonly property string fontFamily: "Inter"
    readonly property string iconFamily: "Material Symbols Rounded"
    readonly property int fontWeight: Font.Medium
    // Point size (not pixels) to match awesome's Pango font description.
    readonly property real fontSize: 8.5

    function withOpacity(value: color, opacity: real): color {
        return Qt.rgba(value.r, value.g, value.b, opacity);
    }

    function mix(from: color, to: color, amount: real): color {
        const ratio = Math.max(0, Math.min(1, amount));
        return Qt.rgba(
            from.r + (to.r - from.r) * ratio,
            from.g + (to.g - from.g) * ratio,
            from.b + (to.b - from.b) * ratio,
            from.a + (to.a - from.a) * ratio,
        );
    }
}
