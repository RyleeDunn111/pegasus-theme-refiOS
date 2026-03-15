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
