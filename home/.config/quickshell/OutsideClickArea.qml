import QtQuick

MouseArea {
    anchors.fill: parent
    z: 1
    acceptedButtons: Qt.AllButtons

    onPressed: (mouse) => {
        OutsideClicks.report();
        mouse.accepted = false;
    }
}
