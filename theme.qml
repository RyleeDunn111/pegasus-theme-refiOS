// Pegasus Frontend - Flixnet theme (Kiosk Optimized)
// Centered layout for P-Stream and Moonlight

import QtQuick 2.7
import QtGraphicalEffects 1.12

FocusScope {
    id: root
    focus: true

    // Load local fonts
    FontLoader { id: roboto_light; source: "assets/fonts/Roboto-Light.ttf"}
    FontLoader { id: roboto_thin; source: "assets/fonts/Roboto-Thin.ttf"}

    // Layout constants
    readonly property real cellRatio: 16 / 9
    readonly property int cellHeight: vpx(150)
    readonly property int cellWidth: cellHeight * cellRatio
    readonly property int cellSpacing: vpx(15)
    readonly property int cellPaddedWidth: cellWidth + cellSpacing

    readonly property int labelFontSize: vpx(20)
    readonly property int labelHeight: labelFontSize * 2.5

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

        // Full-width background art
        Screenshot {
            game: collectionAxis.currentItem.currentGame
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: collectionAxis.top
            }
        }

        // Centered details section
        Details {
            game: collectionAxis.currentItem.currentGame
            anchors {
                top: parent.top
                topMargin: vpx(80)
                left: parent.left
                right: parent.right
                bottom: collectionAxis.top
                bottomMargin: labelHeight
            }
        }

        // Vertical collection list (Centers your apps row)
        PathView {
            id: collectionAxis

            width: parent.width
            height: labelHeight + cellHeight + vpx(20)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: vpx(60)

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
                opacity: PathView.isCurrentItem ? 1.0 : 0.3
                Behavior on opacity { NumberAnimation { duration: 150 } }

                // Collection title centered
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
                        family: "Roboto Light" // Uses fallback if loader fails
                        bold: true
                        capitalization: Font.AllUppercase
                    }
                }

                // Horizontal Carousel (Static path for two centered items)
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

                    // Creates a path that sits perfectly centered on your Vizio
                    pathItemCount: 3
                    path: Path {
                        startX: (gameAxis.width * 0.5) - cellPaddedWidth
                        startY: cellHeight * 0.5
                        PathLine {
                            x: gameAxis.path.startX + (cellPaddedWidth * 2)
                            y: gameAxis.path.startY
                        }
                    }

                    snapMode: PathView.SnapOneItem
                    highlightRangeMode: PathView.StrictlyEnforceRange
                    preferredHighlightBegin: 0.5
                    preferredHighlightEnd: 0.5
                }
            }
        }
    }
}
