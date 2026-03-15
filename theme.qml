// Pegasus Frontend - Custom Kiosk Theme
// Ultra-Minimalist centered layout for P-Stream and Moonlight

import QtQuick 2.7
import QtGraphicalEffects 1.12

FocusScope {
    id: root
    focus: true

    // 4K Optimized Sizes
    readonly property real cellRatio: 16 / 9
    readonly property int cellHeight: vpx(250) // Nice and large for the Vizio
    readonly property int cellWidth: cellHeight * cellRatio
    readonly property int cellSpacing: vpx(80) // Wide gap between the two apps

    Rectangle {
        anchors.fill: parent
        color: "#00050f"

        RadialGradient {
            anchors.fill: parent
            horizontalOffset: vpx(-450)
            verticalOffset: vpx(-250)
            gradient: Gradient {
                GradientStop { position: 0.1; color: "#051720" }
                GradientStop { position: 0.5; color: "#07131d" }
                GradientStop { position: 1; color: "#00050f" }
            }
        }

        // Dimmed Background Art
        Screenshot {
            // Pulls the background of whichever app you are currently selecting
            game: gameList.currentItem ? gameList.currentItem.gameData : null
            anchors.fill: parent
            opacity: 0.3
        }

        // The absolute simplest way to display a row of items
        ListView {
            id: gameList
            focus: true

            // THE FIX: This makes the container exactly the width of your two apps.
            // When combined with centerIn: parent, it creates an unbreakable dead-center alignment.
            width: contentItem.childrenRect.width
            height: cellHeight
            anchors.centerIn: parent

            orientation: ListView.Horizontal
            spacing: cellSpacing

            // THE FIX 2: Bypasses Collections entirely. Just gives us a flat list of your 2 apps.
            model: api.allGames

            delegate: Item {
                id: delegateItem
                width: cellWidth
                height: cellHeight
                property var gameData: modelData // Expose data to the Background Art

                GameAxisCell {
                    game: modelData
                    anchors.fill: parent
                    // ListView natively knows which item is highlighted
                    selected: delegateItem.ListView.isCurrentItem
                    selectedRow: true
                }
            }

            // Interaction Settings
            interactive: false // Completely disables scrolling/mouse dragging
            keyNavigationWraps: true // Pressing right on Moonlight wraps back to P-Stream instantly

            // THE FIX: Explicitly map the Xbox controller's Left/Right inputs to the list index
            Keys.onLeftPressed: decrementCurrentIndex()
            Keys.onRightPressed: incrementCurrentIndex()

            Keys.onPressed: {
                if (!event.isAutoRepeat && api.keys.isAccept(event)) {
                    currentItem.gameData.launch();
                }
            }
        }
    }
}
