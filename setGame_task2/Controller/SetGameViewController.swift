//
//  ViewController.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 05/01/2022.
//

import UIKit

class SetGameViewController: UIViewController {
    
    //MARK: -Properties
    ///
    var displayMode: DisplayMode!
    
    ///The game model reference.
    private var game: Game!
    
    private var gameCards: [Card] {
        self.game.gameCards
    }
    
    private var deckCards: [Card] = []
    
    private var score: Int {
        self.game.score
    }
    
    private var matchesCount: Int {
        self.game.matchedCards.count
    }
    
    ///Adjusts the font to the accessibility settings accordingly.
    private var font: UIFont {
        UIFontMetrics(forTextStyle: .body).scaledFont(for: .preferredFont(forTextStyle: .body).withSize(29.0))
    }
    
    
    //MARK: -Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var matchesCounterLabel: UILabel!
    
    /// The button responsible for triggering the deal cards function in the game.
    @IBOutlet weak var dealCardsButton: UIButton! {
        didSet {
            let action = UIAction { [weak self]_ in
                let alert = UIAlertController(title: "Deal 3 cards", message: "Three cards will be added to the deck. Are you sure?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self?.game.dealCards()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self?.present(alert, animated: true, completion: nil)
            }
            
            dealCardsButton.addAction(action, for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            let action = UIAction { [weak self] _ in
                let alert = UIAlertController(title: "New game", message: "Do you want to create a new game? Any progress you have done so far will be lost.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self?.game.newGame()
                    self?.cardsCollectionView.reloadData()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self?.present(alert, animated: true, completion: nil)
            }
            
            newGameButton.addAction(action, for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var cardsCollectionView: UICollectionView! {
        didSet {
            // layout configuration
            let layout = CardsLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = CollectionViewConsts.sectionSpacing
            layout.minimumInteritemSpacing = CollectionViewConsts.minimumInteritemSpacing
            layout.minimumLineSpacing = CollectionViewConsts.minimumLineSpacing
            
            // functionality configuration
            cardsCollectionView.collectionViewLayout = layout
            cardsCollectionView.delegate = self
            cardsCollectionView.dataSource = self
            
            // view configuration
            cardsCollectionView.layer.cornerRadius = CollectionViewConsts.cornerRadius
            cardsCollectionView.clipsToBounds = true
        }
    }
    
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    
    //MARK: -Actions
    @IBAction func dismissControllerButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true)
    }
    
    
    
    //MARK: -Functions
    
    ///Configures the controller.
    private func configure() -> Void {
        self.game = Game(in: self)
    }
    
    
    private func updateScore(for matchCase: MatchCase) {
        let text = "Score: \(self.score)"
        
        var color: UIColor
        let impact =  UINotificationFeedbackGenerator()
        
        //Handling Impact Feedback generator...
        switch matchCase {
        case .match:
            color = .green
            impact.notificationOccurred(.success)
        case .mismatch:
            color = .red
            impact.notificationOccurred(.error)
        }
        
        self.scoreLabel.text = ""
        self.scoreLabel.textColor = color
        
        
        for (n, ch) in text.enumerated() {
            let interval = (Double(n) + 1.0) * 0.05
            Timer.scheduledTimer(withTimeInterval: interval , repeats: false) { _ in
                self.scoreLabel.text? += String(ch)
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.scoreLabel.textColor = .white
        }

    }
    
}



//MARK: - CollectionView Delegate
extension SetGameViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let itemWidth = (collectionViewWidth / CollectionViewConsts.numberOfItemsInRow) - (2 * CollectionViewConsts.horizontalMargin)
        let itemHeight = itemWidth * SizeRatios.itemHeightToItemWidth
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}


//MARK: - Collectionview Datasource
extension SetGameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.deckCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConsts.cardCellId, for: indexPath) as? CardCell
        else {return UICollectionViewCell()}
        let cellCard = self.deckCards[indexPath.item]
        
        //Cell configuration
        cell.displayMode = self.displayMode
        cell.font = self.font
        cell.card = cellCard
        cell.contentView.backgroundColor = .darkGray
        cell.contentView.layer.cornerRadius = CollectionViewConsts.cornerRadius
        cell.contentView.clipsToBounds = true
        
        cell.actionForChosingCard = {
            self.game.choseCard(at: indexPath.item)
            cell.contentView.backgroundColor = cell.card.isChosen ? .yellow.withAlphaComponent(0.3) : .darkGray
        }
        
        
        return cell
    }
}


//MARK: -Game Delegate
extension SetGameViewController: GameDelegate {
    func didFinishChosingSet(_ chosenSet: [Card], with matchCase: MatchCase) {
        self.updateScore(for: matchCase)
        
        guard matchCase == .match else { return }
        
        self.matchesCounterLabel.text = "Matched: \(self.matchesCount)"
        
        self.cardsCollectionView.performBatchUpdates {
            var indecies = [IndexPath]()
            for card in chosenSet {
                guard let indexOfChosenCardInDeck = self.deckCards.firstIndex(of: card) else { return }
                indecies.append(IndexPath(item: indexOfChosenCardInDeck, section: 0))
            }
            self.cardsCollectionView.deleteItems(at: indecies)
            self.deckCards = self.game.deckCards
        } completion: { [weak self]done in
            guard done, let self = self else { return }
            self.cardsCollectionView.reloadData()
        }
    }
    
    func didFinishDealingCards(_ dealtCards: [Card]?, withError error: SetGameError?) {
        guard let cards = dealtCards, error == nil else {
            let alert = UIAlertController(title: "What the heck!", message: "5alas dol el 2wel ya ro7 Omak ;p", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "7ader", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
            return
        }
        
        for i in 0 ..< cards.count {
            Timer.scheduledTimer(withTimeInterval: Double(i) * ControllerConsts.intervalMultiplier, repeats: false) { _ in
                self.deckCards.append(cards[i])
                let indexPathOfCardToAdd = IndexPath(item: self.deckCards.count - 1, section: 0)
                self.cardsCollectionView.insertItems(at: [indexPathOfCardToAdd])
                
                let isLastItemToAdd = i == cards.count - 1 ? true : false
                if isLastItemToAdd {
                    self.cardsCollectionView.scrollToItem(at: indexPathOfCardToAdd, at: .top, animated: true)
                }
            }
        }
    }
    
    func didFinishChosingCard(_ card: Card, at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let cardCell = self.cardsCollectionView.cellForItem(at: indexPath) as? CardCell
        cardCell?.card.handleHighlighting()
    }
    
    func didDeselectCard(_ card: Card, at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let cardCell = self.cardsCollectionView.cellForItem(at: indexPath) as? CardCell
        cardCell?.card.handleHighlighting()
    }
}


//MARK: -Associated Types
enum DisplayMode: Codable {
    case textual
    case graphical
}


//MARK: -Associated Extensions
extension SetGameViewController {
    private struct CollectionViewConsts {
        static let sectionSpacing: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        static let minimumInteritemSpacing: CGFloat = 0
        static let minimumLineSpacing: CGFloat = 8.0
        static let cornerRadius: CGFloat = 12.0
        static let numberOfItemsInRow: CGFloat = 3.0
        static let horizontalMargin: CGFloat = 8.0
    }
    
    private struct SizeRatios {
        static let itemHeightToItemWidth: CGFloat = 5 / 4
    }
    
    private struct ControllerConsts {
        ///The reuse identifier of the card cell in the cards collectionview.
        static let cardCellId: String = "cardCell"
        static let intervalMultiplier: Double = 0.154
    }
}
