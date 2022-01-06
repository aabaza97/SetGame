//
//  CardCombination.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 05/01/2022.
//

import Foundation
import UIKit

/// The components model of some valid card.
struct CardComponents: Hashable, Equatable {
    var number: CardNumber
    var color: CardColor
    var shape: CardShape
    var shade: CardShade
}

enum CardNumber: Int, CaseIterable {
    case one
    case two
    case three
    
    var value: Int {
        self.rawValue + 1
    }
}

enum CardColor: Int, CaseIterable {
    case red
    case green
    case blue
    
    var value: UIColor {
        switch self {
        case .red: return UIColor.red
        case .green: return UIColor.green
        case .blue: return UIColor.link
        }
    }
}

enum CardShape: Int, CaseIterable {
    case oval
    case diamond
    case squiggle
    
    var value: String {
        switch self {
        case .oval: return "⬮"
        case .diamond: return "♦"
        case .squiggle: return "☡"
        }
    }
}

enum CardShade: Int, CaseIterable {
    case filled
    case striked
    case noFill
}


