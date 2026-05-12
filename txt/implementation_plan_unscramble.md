# Implementation Plan: Unscramble Letters Game

This document outlines the step-by-step plan to replace the current "Spelling Bee" game with an "Unscramble Letters" game, strictly adhering to the requested mechanics.

## 1. Data Structure (Word Puzzles)
Instead of a global dictionary, the game will be driven by predefined puzzle sets. Each puzzle contains a "main word" and an array of valid "sub words" that can be formed from its letters.

```javascript
const PUZZLES = [
    {
        mainWord: "ՍՊԻՏԱԿ",
        subWords: ["ՏԱԿ", "ՍԱԿ", "ՊԱՏ", "ԿԱՊ", "ՍՊԱ", "ՊԱԿԱՍ", /* ... */]
    },
    {
        mainWord: "ԿԱՐԱՍԻ",
        subWords: ["ԿԱՐ", "ՍԱՐ", "ՍԻՐԱՄԱՐԳ", /* etc */] // Example words
    }
    // We will build a robust list of these puzzles.
];
```

## 2. User Interface (UI) Updates
We will modify `spelling-bee.html` (and optionally rename it) to remove the honeycomb design and implement a new layout.

*   **Letter Rack:** A row or circle of the main word's letters, randomly scrambled (e.g., `Ա Տ Պ Ս Կ Ի`). The number of tiles will dynamically adjust based on the main word's length.
*   **Progress Board:** A grid showing placeholder dashes for *every* word the player needs to find. For example, if there is a 3-letter word to find, it shows `_ _ _`. When found, it fills in `Տ Ա Կ`.
*   **Controls:** 
    *   **Shuffle Button:** To re-scramble the letters on the rack.
    *   **Clear Button:** To clear current input.
    *   **Submit Button:** (Or auto-submit when a valid word is typed).

## 3. Core Game Logic
We will completely rewrite `js/spelling-bee.js` to support the new rules:

1.  **Initialization:** On load, randomly select one puzzle from the `PUZZLES` array. Scramble the `mainWord` letters.
2.  **Input Handling:** Players can click the letter tiles or type on their physical keyboard.
3.  **Validation:** 
    *   Check if the entered word exists in the `subWords` array or is the `mainWord`.
    *   If valid and not already found, reveal it on the Progress Board.
    *   If invalid, trigger a shake animation.
4.  **No Mid-Game Saving:** The game state will *not* be saved to LocalStorage. If the user leaves the page and comes back, the script selects a brand new random puzzle.

## 4. Scoring System & Win Condition
The score is accumulated internally during gameplay but is **ONLY** awarded to the user's profile if they successfully complete the puzzle.

**Proposed Point Values:**
*   **Sub Words:** 10 XP per letter (e.g., 3-letter word = 30 XP).
*   **Main Word (Bingo):** 20 XP per letter + 50 XP Bonus (e.g., 6-letter word = 170 XP).
*   **Completion Bonus:** 100 XP for finding all words in the puzzle.

**Win Sequence:**
*   The game constantly checks if `wordsFound.length === puzzle.subWords.length + 1`.
*   When true, the game triggers a "Level Complete" animation.
*   The total accumulated score is finally sent to the database via `window.HaygAPI.updateScore('bee', totalScore)`. This action will also update the user's **streak**.
*   A "Next Puzzle" button appears.

## 5. Execution Steps
1.  **Phase 1: Data & State:** Define the `PUZZLES` array and set up the random selection logic in JS.
2.  **Phase 2: UI Overhaul:** Strip out the hexagonal CSS from `style.css` and build the new Letter Rack and Progress Board in HTML/CSS.
3.  **Phase 3: Logic Wiring:** Implement typing, clicking, shuffling, and validation.
4.  **Phase 4: Win State:** Build the end-game condition, connect the scoring API to only trigger on a win, and add the success animations.

---
**Does this plan align with your vision?** If you approve, I can begin executing Phase 1 and 2 immediately. I will also need a small list of Armenian main words and their sub-words from you to populate the initial game, or I can generate a few examples to start.
