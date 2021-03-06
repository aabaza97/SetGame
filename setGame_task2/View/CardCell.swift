//
//  CardCell.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 06/01/2022.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    //MARK: -Properties
    ///The font the cell shall display its content accordingly.
    var font: UIFont!
    
    ///The card model the cell shall display.
    var card: Card! {
        didSet {
            let cardText = String(repeating: card.shape, count: card.number)
            
            var textAttributes: [NSAttributedString.Key: Any] = [:]
            
            textAttributes[.font] = self.font
            
            switch card.shade {
            case .filled:
                textAttributes[.foregroundColor] = card.color
                break
            case .noFill:
                textAttributes[.strokeColor] = card.color
                textAttributes[.strokeWidth] = 5.0
                break
            case .striked:
                textAttributes[.foregroundColor] = card.color.withAlphaComponent(0.2)
                textAttributes[.strikethroughStyle] = NSUnderlineStyle.thick.rawValue
                textAttributes[.strikethroughColor] = card.color
                break
            }
            
            let attributtedTitle = NSAttributedString(string: cardText, attributes: textAttributes)
            
            self.cardButton.setAttributedTitle(attributtedTitle, for: .normal)
        }
    }
    
    var actionForChosingCard: (() -> Void)?
    
    //MARK: -Outlets
    @IBOutlet weak var cardButton: UIButton! {
        didSet {
            let action = UIAction { [weak self] _ in
                guard let self = self else { return }
                self.actionForChosingCard?()
                self.contentView.backgroundColor =  self.card.isChosen ? .yellow.withAlphaComponent(0.4) : .darkGray
            }
            
            cardButton.addAction(action, for: .touchUpInside)
        }
    }
}


