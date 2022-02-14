//
//  Game.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 05/01/2022.
//

import Foundation
import UIKit



//MARK: -Alias
///A tuple of three cards either with same compoenets or completely different components.
typealias Tripple = (first: Card, second: Card, third: Card)
typealias Quad = (Int, Int, Int, Int)

/// The Set Game.
class Game {
    //MARK: -Properties
    ///The maximum amount of cards to be dealt on deck at a time.
    private let maximumNumberOfCardsOnTable: Int = 24
    
    /// All cards generated at the biginning of the game, the ones on deck and those to be dealt later in game.
    private(set) var gameCards: [Card] = []
    
    /// All cards visible to the user. The bank is not included.
    private(set) var deckCards: [Card] = []
    
    /// The matched set of cards. They're either all have same components or completely different ones.
    private(set) var matchedCards: [Tripple] = [] {
        didSet {
            guard matchedCards.count > 0 else { return }
            self.handleMatching(for: .match)
        }
    }
    
    /// The selected cards
    private(set) var chosenCardsForMatching = [Card]() {
        didSet {
            if chosenCardsForMatching.count == 3 {
                self.checkChosenCardsMatchStatus()
            }
        }
    }
    
    /// The game score tracker.
    private(set) var score: Int = 0 {
        didSet {
            if score < 0 { score = 0 }
        }
    }
    
    ///The game delegate corresponding to game events.
    weak var delegate: GameDelegate?
    
    
    //MARK: -Inits
    
    init(in controller: GameDelegate) {
        self.delegate = controller
        self.newGame()
    }
    
    
    //MARK: -Functions
    ///Resets the game and creates a new one.
    func newGame() -> Void {
        // Reset the game.
        self.score = 0
        self.gameCards.removeAll()
        self.chosenCardsForMatching.removeAll()
        self.deckCards.removeAll()
        self.matchedCards.removeAll()
        
        // Generate cards.
        self.generateCards()
        
        //Deal 12 cards at the beginning of every new game.
        self.dealCards(amountToDeal: 12)
    }
    
    /// Generates all possible combinations of cards to be used in game.
    private func generateCards() -> Void {
        var cards: [Card] = []
        
        CardNumber.allCases.forEach { number in
            CardColor.allCases.forEach { color in
                CardShape.allCases.forEach { shape in
                    CardShade.allCases.forEach { shade in
                        let cardComponents = CardComponents(number: number, color: color, shape: shape, shade: shade)
                        let card = Card(componenets: cardComponents)
                        cards.append(card)
                    }
                }
            }
        }
        
        self.gameCards = cards.shuffled()
    }
    
    /// Deals the provided amount of cards from the bank to the deck.
    func dealCards(amountToDeal amount: Int = 3) -> Void {
        
        // If the game cards has less than the amount to deal, the delegate is notified with a SetGameError
        guard amount > 0, self.gameCards.count > amount else {
            self.delegate?.didFinishDealingCards(nil, withError: .NoMoreCardsToDeal)
            return
        }
        
        // If the deck cards has reached the maximum amount, the delegate is notified with a SetGameError
        guard self.deckCards.count < self.maximumNumberOfCardsOnTable else {
            self.delegate?.didFinishDealingCards(nil, withError: .ReachedMaximumAmountOfCardsOnDeck)
            return
        }
        
        var dealtCards: [Card] = []
        
        for _ in 0 ..< amount {
            let dealtCard = self.gameCards.removeFirst()
            self.deckCards.append(dealtCard)
            dealtCards.append(dealtCard)
        }
        
        self.delegate?.didFinishDealingCards(dealtCards, withError: nil)
    }
    
    /// Choses a card at a specific index. When 3 cards are selected the matching check is going to get triggered.
    func choseCard(at index: Int) -> Void {
        guard index < self.deckCards.count else { return }
        var chosenCard = self.deckCards[index]
        
        /*
         Cases:
         1. Card has been chosen before, aka in the the chosenCardsForMatching
         2. Already picked 3 cards -- go check for matching (Handled in the didSet of the chosendCardsForMatching property)
         */
        
        //1. If card has not been chosen before, add it. Otherwise, remove it
        if !self.chosenCardsForMatching.contains(chosenCard) {
            chosenCard.handleHighlighting()
            self.chosenCardsForMatching.append(chosenCard)
            self.delegate?.didFinishChosingCard(chosenCard, at: index)
        } else {
            guard let indexOfPreviouslyChosenCard = self.chosenCardsForMatching.firstIndex(of: chosenCard) else { return }
            chosenCard = self.chosenCardsForMatching[indexOfPreviouslyChosenCard]
            chosenCard.handleHighlighting()
            self.chosenCardsForMatching.remove(at: indexOfPreviouslyChosenCard)
            self.delegate?.didDeselectCard(chosenCard, at: indexOfPreviouslyChosenCard)
        }
        
    }
    
    
    /// Applies the game rule of either equal components or completely different components.
    /// When new match is found it gets added to the matchedCards property and cleaning function is performed.
    private func checkChosenCardsMatchStatus() -> Void {
        guard self.chosenCardsForMatching.count == 3 else { return }
        
        /*
         Game rule:
            All Cards must have either equal components or completely different components.
         
         When matched:
            - A tripple is made of the three cards and appended to the matched cards.
            - <<<!!!>>> Note: Matching handler gets triggered in the didSet of the matchedCards. <<<!!!>>>
         
         No match:
            - Clears the list of chosen cards.
            - Matching handler gets triggered.
         */
        
        let groupedByNumber = Dictionary(grouping: self.chosenCardsForMatching, by: {$0.componenets.number}).count.eitherAllOrNone
        
        let groupedByShape = Dictionary(grouping: self.chosenCardsForMatching, by: {$0.componenets.shape}).count.eitherAllOrNone
        
        let groupedByShade = Dictionary(grouping: self.chosenCardsForMatching, by: {$0.componenets.shade}).count.eitherAllOrNone
        
        let groupedByColor = Dictionary(grouping: self.chosenCardsForMatching, by: {$0.componenets.color}).count.eitherAllOrNone
        
        
        
        guard groupedByNumber, groupedByShade, groupedByColor, groupedByShape else {
            //TODO: clear selection...
            self.handleMatching(for: .mismatch)
            self.chosenCardsForMatching.removeAll()
            return
        }
        
        
        let newMatch: Tripple = (
            first: self.chosenCardsForMatching[0],
            second: self.chosenCardsForMatching[1],
            third: self.chosenCardsForMatching[2]
        )
        
        self.matchedCards.append(newMatch)
        self.removeMatchedCardsFromTable(of: newMatch)
        //calls the function responsible for notifying the delegate of the game.
        self.delegate?.didFinishChosingSet([newMatch.first, newMatch.second, newMatch.third], with: .match)
    }
    
    
    /// Removes the matched tripple from the visible cards on table and clears the chosen cards for matching property.
    private func removeMatchedCardsFromTable(of matchedTripple: Tripple) -> Void {
        let deckCountBeforeRemoval = self.deckCards.count
        for card in self.deckCards {
            if let indexOfTheCardOnTable = self.deckCards.firstIndex(of: card),
               (card == matchedTripple.first || card == matchedTripple.second || card == matchedTripple.third)
            {
                self.deckCards.remove(at: indexOfTheCardOnTable)
            }
            
            if (deckCountBeforeRemoval - self.deckCards.count) == 3  {
                break
            }
        }
        
        self.chosenCardsForMatching.removeAll()
    }
    
    
    /// Handles the the the matching status in case either a match or a mismatch.
    /// Calls the function responsible for notifying the delegate of the game.
    ///  - parameter - scoreCase: Enum case indicates the wheather the user made a match.
    private func handleMatching(for matchCase: MatchCase) {
        switch matchCase {
        case .match:
            self.score += 10
        case .mismatch:
            self.score -= 5
            self.delegate?.didFinishChosingSet(self.chosenCardsForMatching, with: matchCase)
        }
        
//        //calls the function responsible for notifying the delegate of the game.
//        self.delegate?.didFinishChosingSet(self.chosenCardsForMatching, with: matchCase)
    }
    
    
}



//MARK: - Associated Extensions
extension Int {
    ///For a set of three cards, returns true if the integer is 1 (all cards match) or 3 (all cards are different).
    var eitherAllOrNone: Bool {
        self == 1 || self == 3
    }
}


//MARK: -Associated Protocols
protocol GameDelegate: AnyObject {
    ///Notifies the delegate when a set of cards chosen for matching did match or not.
    func didFinishChosingSet(_ chosenSet: [Card], with matchCase: MatchCase) -> Void
    
    ///Notifies the delegate when new cards are added to the table.
    func didFinishDealingCards(_ dealtCards: [Card]?, withError error: SetGameError?) -> Void
    
    ///Notifies the delegate when a card is chosen.
    func didFinishChosingCard(_ card: Card, at index: Int) -> Void
    
    ///Notifies the delegate when a card is deselected.
    func didDeselectCard(_ card: Card, at index: Int) -> Void
}



//MARK: -Associated Enums
enum SetGameError: Error {
    case ReachedMaximumAmountOfCardsOnDeck
    case NoMoreCardsToDeal
}
