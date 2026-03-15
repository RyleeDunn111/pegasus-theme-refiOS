import QtQuick 2.7  // <-- FIXED: Updated to 2.7 to support mipmap
import QtGraphicalEffects 1.12

Item {
    id: root
    property var game
    property bool selected: false
    property bool selectedRow: false

    // 1. The Custom Console Glow
    Rectangle {
        anchors.fill: parent
        anchors.margins: vpx(-6)
        color: "transparent"
        border.color: selected ? "#8183f9" : "transparent"
        border.width: vpx(6)
        radius: vpx(24)

        // Smooth fade in/out when moving between apps
        Behavior on border.color { ColorAnimation { duration: 150 } }
    }

    // 2. The App Icon
    Image {
        id: appIcon
        anchors.fill: parent

        // <-- FIXED: Now looks for 'boxFront' to match the metadata.txt update
        source: game && game.assets.boxFront ? game.assets.boxFront : ""

        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true

        // Clips the icon into a smooth rounded square (Apple TV style)
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: appIcon.width
                height: appIcon.height
                radius: vpx(18)
            }
        }
    }

    // Ensure the size stays completely static
    scale: 1.0
}
