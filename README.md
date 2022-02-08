# SetGame
The second assignment of Stanford's CS193P (iOS Development).

# Screenshots
### Using Textual Representation
Cards here are represented using `NSAttributedString`
<img src="https://github.com/aabaza97/SetGame/blob/GameLogic/IMG_1502.PNG" width=35% height=35%>
### Using Graphical Representation
Cards here are represented using `UIBezzierPath`
<img src="https://github.com/aabaza97/SetGame/blob/GameLogic/IMG_002.PNG" width=35% height=35%>

# Game Rule
All Cards must have either equal components or completely different components.

# Card Components
Each card is formed of some components expressed in enumerations. These components are: 
1. Number (1, 2, 3)
2. Color (Red, Green, Blue)
3. Shape (Oval, Squiggle, Diamond)
4. Shade (Filled, Outlined, Striked)

# Brief
The game starts showing 12 different and shuffled cards after generating all possible valid combinations of Card Components.
Once 3 cards are chosen, a set is formed and gets checked for match following the game rule. If they match, the score is increased by 10, and the matches are increased by 1. However, if the set chosen is no match, 5 points are subtracted from the player's score. If the user can't find a set to form in the cards displayed on the screen, they have the ability to deal 3 cards at a time with a maximum amount of 24 cards to be displayed at a time... (Thinking about adding a cost for this one.. haha!)

# Implementation Using
- Swift 5
- UIKit
- UICollectionView


