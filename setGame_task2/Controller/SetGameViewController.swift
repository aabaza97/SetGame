//
//  ViewController.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 05/01/2022.
//

import UIKit

class SetGameViewController: UIViewController {
    
    //MARK: -Properties
    
    ///The reuse identifier of the card cell in the cards collectionview.
    private let cardCellId: String = "cardCell"
    
    private var game: Game!
    
    private var gameCards: [Card] {
        self.game.gameCards
    }
    
    private var deckCards: [Card] {
        self.game.deckCards
    }
    
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
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 8.0
            
            // functionality configuration
            cardsCollectionView.collectionViewLayout = layout
            cardsCollectionView.delegate = self
            cardsCollectionView.dataSource = self
            
            // view configuration
            cardsCollectionView.layer.cornerRadius = 12.0
            cardsCollectionView.clipsToBounds = true
        }
    }
    
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    
    
    //MARK: -Functions
    
    ///Configures the controller.
    private func configure() -> Void {
        self.game = Game()
        self.game.delegate = self
    }
    
    
    private func updateScore(for matchCase: MatchCase) {
        let text = "Score: \(self.score)"
        
        var color: UIColor
        let impact =  UINotificationFeedbackGenerator()
        
        
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
        let width = collectionView.frame.size.width / 3 - (16)
        let height = width * 13 / 11
        return CGSize(width: width, height: height)
    }
    
}


//MARK: - Collectionview Datasource
extension SetGameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.deckCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cardCellId, for: indexPath) as? CardCell
        else {return UICollectionViewCell()}
        
        //Cell Configuration
        cell.font = self.font
        cell.card = self.game.deckCards[indexPath.item]
        cell.contentView.backgroundColor = .darkGray
        cell.contentView.layer.cornerRadius = 12.0
        cell.contentView.clipsToBounds = true
        
        cell.actionForChosingCard = {
            self.game.choseCard(at: indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.game.deckCards[indexPath.row].shape)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        true
    }

}


//MARK: -Game Delegate
extension SetGameViewController: GameDelegate {
    func didFinishChosingSet(_ chosenSet: [Card], with matchCase: MatchCase) {
        self.updateScore(for: matchCase)
        self.matchesCounterLabel.text = "Matched: \(self.matchesCount)"
        self.cardsCollectionView.reloadData()
    }
    
    func didFinishDealingCards(_ dealtCards: [Card]?, withError error: SetGameError?) {
        guard error == nil else {
            let alert = UIAlertController(title: "What the heck!", message: "5alas dol el 2wel ya ro7 Omak ;p", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "7ader", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
            return
        }
        self.cardsCollectionView.reloadData()
    }
    
    func didFinishChosingCard(_ card: Card, at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let cardCell = self.cardsCollectionView.cellForItem(at: indexPath) as? CardCell
        cardCell?.card.markChosen()
    }
    
    func didDeselectCard(_ card: Card, at index: Int) {
        
    }
}
