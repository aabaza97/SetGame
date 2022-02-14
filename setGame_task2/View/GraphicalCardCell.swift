//
//  GraphicalCardCell.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 08/02/2022.
//

import UIKit

class GraphicalCardCell: UICollectionViewCell {
    
    
    var card: Card! {
        didSet {
            cardButton.card = self.card
        }
    }
    
    @IBOutlet weak var cardButton: GraphicsCardButton! {
        didSet {
            let action = UIAction { [weak self] _ in
                guard let self = self else { return }
                self.actionForChosingCard?()
                self.contentView.backgroundColor =  self.card.isChosen ? .yellow.withAlphaComponent(0.4) : .darkGray
            }
            
            cardButton.addAction(action, for: .touchUpInside)
        }
    }
    
    
    var actionForChosingCard: (() -> Void)?
}
