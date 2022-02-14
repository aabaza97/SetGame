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
    
    ///The mode in which the card content to be represented.
    var displayMode: DisplayMode! {
        didSet {
            switch displayMode {
            case .textual:
                self.textualCardButton.isHidden = false
                self.graphicsCardButton.isHidden = true
            case .graphical:
                self.textualCardButton.isHidden = true
                self.graphicsCardButton.isHidden = false
            case .none: break
            }
        }
    }
    
    ///The card model the cell shall display.
    var card: Card! {
        didSet {
            switch displayMode {
            case .textual:
                self.configureCardForTextualRepresentation()
            case .graphical:
                self.graphicsCardButton.card = self.card
            case .none: return
            }
            
        }
    }
    
    ///The handler triggered when a button is tapped.
    var actionForChosingCard: (() -> Void)?
    
    
    
    //MARK: -Outlets
    @IBOutlet weak var textualCardButton: UIButton! {
        didSet {
            textualCardButton.backgroundColor = .clear
            textualCardButton.addAction(self.configureButtonAction(), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var graphicsCardButton: GraphicsCardButton! {
        didSet {
            graphicsCardButton.backgroundColor = .clear
            graphicsCardButton.addAction(self.configureButtonAction(), for: .touchUpInside)
        }
    }
    
    
    
    //MARK: -Functions
    private func configureButtonAction() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else { return }
            self.actionForChosingCard?()
//            self.contentView.backgroundColor =  self.card.isChosen ? .yellow.withAlphaComponent(0.4) : .darkGray
        }
    }
    
    ///Configures the card using textual repsentation of  its content.
    private func configureCardForTextualRepresentation() -> Void {
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
        
        self.textualCardButton.setAttributedTitle(attributtedTitle, for: .normal)
    }
    
    
}

//MARK: -Associated Extensions
extension UIButton {
    func pinToEdges(of view: UIView) -> UIButton {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.updateConstraintsIfNeeded()
        return self
    }
}


