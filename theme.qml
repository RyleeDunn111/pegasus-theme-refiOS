// Pegasus Frontend - Flixnet theme (Kiosk Optimized Version)
// Modified for P-Stream / Moonlight centered layout

import QtQuick 2.7
import QtGraphicalEffects 1.12

FocusScope {
    id: root
    focus: true

    // Load local fonts
    FontLoader { id: roboto_light; source: "assets/fonts/Roboto-Light.ttf"}
    FontLoader { id: roboto_thin; source: "assets/fonts/Roboto-Thin.ttf"}

    // Grid constants optimized for 4K
    readonly property real cellRatio: 16 / 9
    readonly property int cellHeight: vpx(180) // Slightly taller for 4K visibility
    readonly property int cellWidth: cellHeight * cellRatio
    readonly property int cellSpacing: vpx(20)
    readonly property int cellPaddedWidth: cellWidth + cellSpacing

    // UI Labels
    readonly property int labelFontSize: vpx(22)
    readonly property int labelHeight: labelFontSize * 3

    Rectangle {
        anchors.fill: parent
        color: "#00050f" // Deep base color

        // Premium background gradient
        RadialGradient {
            anchors.fill: parent
            horizontalOffset: vpx(-200)
            verticalOffset: vpx(-100)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#0a1f2c" }
                GradientStop { position: 0.6; color: "#07131d" }
                GradientStop { position: 1.0; color: "#00050f" }
            }
        }

        // Backdrops with fallback logic
        Screenshot {
            id: backgroundArt
            game: collectionAxis.currentItem.currentGame
            anchors.fill: parent
            opacity: 0.4 // Dimmed for readability
            // Fallback to a default if no screenshot exists
            source: (game && game.assets.background) ? game.assets.background : "assets/images/default_bg.jpg"
            fillMode: Image.PreserveAspectCrop
        }

        // Center-aligned Game Details
        Details {
            game: collectionAxis.currentItem.currentGame
            anchors {
                top: parent.top
                topMargin: vpx(100)
                left: parent.left
                right: parent.right
                bottom: collectionAxis.top
            }
            // Ensure child components in Details.qml are also centered if possible
        }

        // Main Vertical Axis
        PathView {
            id: collectionAxis

            width: parent.width
            height: labelHeight + cellHeight + vpx(50)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: vpx(100)

            model: api.collections
            delegate: collectionAxisDelegate

            pathItemCount: 3
            path: Path {
                startX: collectionAxis.width * 0.5
                startY: 0
                PathLine {
                    x: collectionAxis.width * 0.5
                    y: collectionAxis.height
                }
            }

            snapMode: PathView.SnapOneItem
            highlightRangeMode: PathView.StrictlyEnforceRange
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5

            focus: true
            Keys.onUpPressed: decrementCurrentIndex()
            Keys.onDownPressed: incrementCurrentIndex()
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
                readonly property bool currentRow: PathView.isCurrentItem

                width: PathView.view.width
                height: labelHeight + cellHeight

                visible: PathView.onPath
                opacity: PathView.isCurrentItem ? 1.0 : 0.2
                Behavior on opacity { NumberAnimation { duration: 200 } }

                // Centered Collection Name
                Text {
                    text: modelData.name || modelData.shortName
                    height: labelHeight
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.top: parent.top

                    color: "white"
                    font {
                        pixelSize: labelFontSize
                        family: roboto_light.name
                        bold: true
                        capitalization: Font.AllUppercase
                        letterSpacing: 2
                    }
                }

                // Horizontal Game Carousel (Centered)
                PathView {
                    id: gameAxis
                    width: parent.width
                    height: cellHeight
                    anchors.bottom: parent.bottom

                    model: games
                    delegate: GameAxisCell {
                        game: modelData
                        width: cellWidth
                        height: cellHeight
                        selected: PathView.isCurrentItem
                        selectedRow: currentRow
                    }

                    readonly property var currentGame: games.get(currentIndex)

                    // FIXED: This prevents the "swapping" bounce for 2 items
                    pathItemCount: 5

                    path: Path {
                        // Math to start the path centered
                        startX: (gameAxis.width * 0.5) - (cellPaddedWidth * (gameAxis.currentIndex))
                        startY: cellHeight * 0.5
                        PathLine {
                            x: gameAxis.path.startX + (cellPaddedWidth * (gameAxis.model.count - 1))
                            y: gameAxis.path.startY
                        }
                    }

                    snapMode: PathView.SnapOneItem
                    highlightRangeMode: PathView.StrictlyEnforceRange

                    // Force the active app to stay in the exact center of the Vizio
                    preferredHighlightBegin: 0.5
                    preferredHighlightEnd: 0.5
                }
            }
        }
    }
}
