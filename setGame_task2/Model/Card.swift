//
//  Card.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 05/01/2022.
//

import Foundation
import UIKit

/// A model wrapper for a card components.
struct Card: Equatable {
    //MARK: -Properties
    /// The components forming the card.
    var componenets: CardComponents
    
    /// The selection flag of the card itself.
    private(set) var isChosen: Bool = false
    
   
    ///The value of the color component of the card.
    var color: UIColor {
        self.componenets.color.value
    }
    
    ///The value of the shape component of the card.
    var shape: String {
        self.componenets.shape.value
    }
    
    ///The value of the shade component of the card.
    var shade: CardShade {
        self.componenets.shade
    }
    
    ///The value of the number component of the card.
    var number: Int {
        self.componenets.number.value
    }
    
    
    
    //MARK: -Functions
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.componenets == rhs.componenets
    }
    
    /// Mutates the selection flag of the card.
    mutating func markChosen() -> Void {
        self.isChosen = !self.isChosen
    }
    
}


