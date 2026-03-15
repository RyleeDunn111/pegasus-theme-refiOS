// Pegasus Frontend - Flixnet theme (Kiosk Optimized)
// Ultra-Minimalist centered layout for P-Stream and Moonlight

import QtQuick 2.7
import QtGraphicalEffects 1.12

FocusScope {
    id: root
    focus: true

    // Grid constants
    readonly property real cellRatio: 16 / 9
    readonly property int cellHeight: vpx(200)
    readonly property int cellWidth: cellHeight * cellRatio
    readonly property int cellSpacing: vpx(40)
    readonly property int cellPaddedWidth: cellWidth + cellSpacing

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

        // Background art (No labels/details on top)
        Screenshot {
            game: collectionAxis.currentItem.currentGame
            anchors.fill: parent
            opacity: 0.3
        }

        // Main App Container - Centered Vertically and Horizontally
        PathView {
            id: collectionAxis

            width: parent.width
            height: cellHeight
            anchors.centerIn: parent

            model: api.collections
            delegate: collectionAxisDelegate

            pathItemCount: 1
            path: Path {
                startX: collectionAxis.width * 0.5
                startY: collectionAxis.height * 0.5
                PathLine {
                    x: collectionAxis.width * 0.5
                    y: collectionAxis.height * 0.5
                }
            }

            focus: true
            Keys.onLeftPressed: currentItem.axis.decrementCurrentIndex()
            Keys.onRightPressed: currentItem.axis.incrementCurrentIndex()
            Keys.onPressed: {
                if (!event.isAutoRepeat && api.keys.isAccept(event))
                    currentItem.currentGame.launch();
            }
        }

        Component {
            id: collectionAxisDelegate

            Item {
                property alias axis: gameAxis
                readonly property var currentGame: axis.currentGame

                width: parent.width
                height: cellHeight

                // Horizontal App List
                PathView {
                    id: gameAxis
                    width: parent.width
                    height: cellHeight
                    anchors.centerIn: parent

                    model: games
                    delegate: GameAxisCell {
                        game: modelData
                        width: cellWidth
                        height: cellHeight
                        selected: PathView.isCurrentItem
                        selectedRow: true
                    }

                    readonly property var currentGame: games.get(currentIndex)

                    // Stagnant Layout: 2 items centered
                    pathItemCount: 2
                    interactive: false

                    path: Path {
                        // FIX: Calculate start point so the center of the gap is the center of the screen
                        startX: (gameAxis.width * 0.5) - (cellPaddedWidth * 0.5)
                        startY: cellHeight * 0.5
                        PathLine {
                            x: gameAxis.path.startX + cellPaddedWidth
                            y: gameAxis.path.startY
                        }
                    }

                    snapMode: PathView.SnapOneItem
                    highlightRangeMode: PathView.StrictlyEnforceRange

                    // This ensures the navigation snaps exactly between the two centered points
                    preferredHighlightBegin: 0.5
                    preferredHighlightEnd: 0.5
                }
            }
        }
    }
}
