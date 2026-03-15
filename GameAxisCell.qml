import QtQuick 2.0
import QtGraphicalEffects 1.12

Item {
    id: root
    property var game
    property bool selected: false
    property bool selectedRow: false

    // 1. The Custom Console Glow (Matches your web app!)
    Rectangle {
        anchors.fill: parent
        anchors.margins: vpx(-6) // Pushes the border slightly outside the icon
        color: "transparent"
        border.color: selected ? "#8183f9" : "transparent"
        border.width: vpx(6)
        radius: vpx(24) // Matches the rounded corners of the icon below

        // Smooth fade in/out when moving between apps
        Behavior on border.color { ColorAnimation { duration: 150 } }
    }

    // 2. The App Icon
    Image {
        id: appIcon
        anchors.fill: parent

        // Explicitly pull the icon we defined in metadata.txt
        source: game && game.assets.icon ? game.assets.icon : ""

        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true

        // Optional: Clips the icon into a smooth rounded square (Apple TV style)
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: appIcon.width
                height: appIcon.height
                radius: vpx(18)
            }
        }
    }

    // Ensure the size stays completely static (no bouncing)
    scale: 1.0
}
