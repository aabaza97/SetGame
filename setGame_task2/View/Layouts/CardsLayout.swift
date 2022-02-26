//
//  CardsLayout.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 13/02/2022.
//

import UIKit

class CardsLayout: UICollectionViewFlowLayout {
    
    private var animates: Bool {
        UserDefaults.standard.bool(forKey: "animates")
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)

        if animates {
            guard let collectionView = self.collectionView else { return attrs }
            let translationDirection = Translations.fromLeft(of: collectionView).coordinates
            let _ = CGAffineTransform(translationX: translationDirection.x, y: translationDirection.y)
            let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            attrs?.transform = scaleTransform
        }
        
        return attrs
    }
    
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        if animates {
            guard let collectionView = self.collectionView else { return attrs }
            let translationDirection = Translations.toRight(of: collectionView).coordinates
            let _ = CGAffineTransform(translationX: translationDirection.x, y: translationDirection.y)
            let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            attrs?.transform = scaleTransform
        } 
        
        return attrs
    }
}



//MARK: -Associated Extensions
extension CardsLayout {
    ///The direction of the translation taking effect.
    private enum Translations {
        case fromLeft(of: UIView)
        case toRight (of: UIView)
        case none
        
        var coordinates: (x: CGFloat, y: CGFloat) {
            switch self {
            case .fromLeft(let view):
                return (x: -(view.frame.width), y: view.frame.height)
            case .toRight(let view):
                return (x: view.frame.width, y: view.frame.height)
            case .none:
                return (0,0)
            }
        }
    }
}
