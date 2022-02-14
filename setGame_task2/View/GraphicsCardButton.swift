//
//  GraphicsCardButton.swift
//  setGame_task2
//
//  Created by Ahmed Abaza on 01/02/2022.
//

import UIKit

class GraphicsCardButton: UIButton {

    //MARK: -Properties
    var card: Card? { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var number: Int {
        self.card?.number ?? 0
    }
    
    var shape: CardShape {
        self.card?.componenets.shape ?? .diamond
    }
    
    var shade: CardShade {
        self.card?.shade ?? .noFill
    }
    
    var color: UIColor {
        self.card?.color ?? .clear
    }
    
    var strokeWidth: CGFloat {
        SizeRatios.strokeWidthToFrameWidth * self.width
    }
    
    
    
    //MARK: -LifeCycle
    override func draw(_ rect: CGRect) {
        guard self.card != nil else { return }
        var shapePath: UIBezierPath = UIBezierPath()
        
        self.color.setFill()
        self.color.setStroke()
        
        switch self.shape {
        case .oval: shapePath = self.drawOval()
        case .diamond: shapePath = self.drawDiamond()
        case .squiggle: shapePath = self.drawSquiggle()
        }
        
        shapePath.lineWidth = self.strokeWidth
        shapePath.addClip()
        
        switch self.shade {
        case .filled:
            shapePath.fill()
        case .noFill:
            //aka stroked
            shapePath.stroke()
            break
        case .striked:
            shapePath.stroke()
            self.strikePath().stroke()
            break
        }
        
        
    }
    
    
    //MARK: -Functions
    private func drawOval() -> UIBezierPath {
        let shapeSize = CGSize(
            width: (self.width - (2 * LayoutSpaces.horizontalMargin)) / Constants.maximumShapesNumber,
            height: self.height - (2 * LayoutSpaces.verticalMargin)
        )
        
        
        let pathOrigin = CGPoint(
            x: self.bounds.midX - (CGFloat(number) * (shapeSize.width / 2)),
            y: self.bounds.origin.y + LayoutSpaces.verticalMargin
        )
        
        let path = UIBezierPath()
        
        for shapeNumber in 0 ..< self.number {
            let offset = (CGFloat(shapeNumber) * shapeSize.width) + (CGFloat(shapeNumber) * LayoutSpaces.spaceBetweenShapes)
            let drawOriginForShape = CGPoint(
                x: pathOrigin.x + offset,
                y: pathOrigin.y
            )
            let drawRect = CGRect(origin: drawOriginForShape, size: shapeSize)
            let ovalPath = UIBezierPath(ovalIn: drawRect)
            path.append(ovalPath)
        }
        
        return path
    }
    
    private func drawDiamond() -> UIBezierPath {
        let shapeSize = CGSize(
            width: (self.width - (2 * LayoutSpaces.horizontalMargin)) / Constants.maximumShapesNumber, 
            height: self.height - (2 * LayoutSpaces.verticalMargin)
        )
        let drawRectWidth = (CGFloat(self.number) * shapeSize.width) + (CGFloat(self.number) * LayoutSpaces.spaceBetweenShapes)
        let drawOrigin = CGPoint(x: (self.width - drawRectWidth) / 2, y: LayoutSpaces.verticalMargin)
        
        let path = UIBezierPath()
        
        for shapeNumber in 0 ..< self.number {
            let drawX = drawOrigin.x + (shapeSize.width * CGFloat(shapeNumber)) + (LayoutSpaces.spaceBetweenShapes * CGFloat(shapeNumber))
            
            let drawPoint = CGPoint(x: drawX  + (shapeSize.width / 2), y: drawOrigin.y)
            let leftCornerPoint = CGPoint(x: drawX, y: self.bounds.midY)
            let bottomCornerPoint = CGPoint(x: drawPoint.x, y: drawPoint.y + shapeSize.height)
            let rightCornerPoint = CGPoint(x: drawX + shapeSize.width, y: self.bounds.midY)
            
            path.move(to: drawPoint)
            path.addLine(to: leftCornerPoint)
            path.addLine(to: bottomCornerPoint)
            path.addLine(to: rightCornerPoint)
            path.close()
        }
        
        return path
    }
    
    private func drawSquiggle() -> UIBezierPath {
        let shapeSize = CGSize(
            width: (self.width - (4 * LayoutSpaces.horizontalMargin)) / Constants.maximumShapesNumber,
            height: self.height - (2 * LayoutSpaces.verticalMargin)
        )
        
        let drawRectWidth = (CGFloat(self.number) * shapeSize.width) + (CGFloat(self.number) * LayoutSpaces.spaceBetweenShapes) + (2 * LayoutSpaces.horizontalMargin)
        let drawOrigin = CGPoint(x: (self.width - drawRectWidth) / 2, y: LayoutSpaces.verticalMargin)
        let path = UIBezierPath()
        
        
        /*
         NOTE:
         - (shapeSize.width / 2) yields the center X coordinate of the shape
         */
        for shapeNumber in 0 ..< self.number {
            let drawX = drawOrigin.x + (shapeSize.width * CGFloat(shapeNumber)) + (LayoutSpaces.spaceBetweenShapes * CGFloat(shapeNumber)) + LayoutSpaces.horizontalMargin
            let drawPoint = CGPoint(x: drawX, y: drawOrigin.y )
            
            let topQuadCurveEndPoint = CGPoint(x: drawPoint.x + shapeSize.width, y: drawPoint.y)
            let topQuadCurveControlPoint = CGPoint(x: drawPoint.x + (shapeSize.width / 2), y: drawPoint.y - (shapeSize.width / 2))
            
            let rightCurveEndPoint = CGPoint(x: drawPoint.x + shapeSize.width, y: shapeSize.height + LayoutSpaces.verticalMargin)
            let rightCurveControlPoint1 = CGPoint(x: topQuadCurveEndPoint.x - (shapeSize.width / 2), y: self.bounds.midY)
            let rightCurveControlPoint2 = CGPoint(x: topQuadCurveEndPoint.x + (shapeSize.width / 2), y: self.bounds.midY)
            
            let bottomQuadCurveEndPoint = CGPoint(x: drawPoint.x, y: shapeSize.height + LayoutSpaces.verticalMargin)
            let bottomQuadCurveControlPoint = CGPoint(x: drawPoint.x + (shapeSize.width / 2), y: shapeSize.height + LayoutSpaces.verticalMargin + (shapeSize.width / 2) )
            
            let leftCurveEndPoint = drawPoint
            let leftCurveControlPoint1 = CGPoint(x: leftCurveEndPoint.x + (shapeSize.width / 2) , y: self.bounds.midY)
            let leftCurveControlPoint2 = CGPoint(x: leftCurveEndPoint.x - (shapeSize.width / 2) , y: self.bounds.midY)
            
            path.move(to: drawPoint)
            path.addQuadCurve(to: topQuadCurveEndPoint, controlPoint: topQuadCurveControlPoint)
            path.addCurve(to: rightCurveEndPoint, controlPoint1: rightCurveControlPoint1, controlPoint2: rightCurveControlPoint2)
            path.addQuadCurve(to: bottomQuadCurveEndPoint, controlPoint: bottomQuadCurveControlPoint)
            path.addCurve(to: leftCurveEndPoint, controlPoint1: leftCurveControlPoint1, controlPoint2: leftCurveControlPoint2)
            path.close()
        }
        
        return path
    }
    
    private func strikePath() -> UIBezierPath {
        let strikeWidth = SizeRatios.strikeWidthToFrameWidth * self.width
        let spaceBetweenStrikes = SizeRatios.spaceBetweenStrikesToFrameWidth * self.width
        let offsetStep = strikeWidth + spaceBetweenStrikes
        let path = UIBezierPath()
        
        for xCoordinate in stride(from: 0, to: self.width, by: offsetStep) {
            let drawPoint = CGPoint(x: xCoordinate, y: self.originY)
            let endPoint = CGPoint(x: xCoordinate, y: self.height)
            
            path.move(to: drawPoint)
            path.addLine(to: endPoint)
        }
        
        path.lineWidth = strikeWidth
        
        return path
    }
}


//MARK: -Associated Extentions
extension GraphicsCardButton {
    private struct SizeRatios{
        static let strokeWidthToFrameWidth: CGFloat = 0.03
        static let strikeWidthToFrameWidth: CGFloat = 0.0085
        static let spaceBetweenStrikesToFrameWidth: CGFloat = 0.04
        static let curverOffsetToShapeWidth: CGFloat = 0.04
    }
    
    private struct LayoutSpaces{
        static let spaceBetweenShapes: CGFloat = 5.0
        static let horizontalMargin: CGFloat = 12.0
        static let verticalMargin: CGFloat = 24.0
    }
    
    private struct Constants {
        static let maximumShapesNumber: CGFloat = 3
    }
}



extension CGPoint {
    func offsetBy (dx: CGFloat, dy: CGFloat) -> CGPoint {
        CGPoint(x: self.x + dx , y: self.y + dy)
    }
}


extension UIView {
    var width: CGFloat {
        self.frame.size.width
    }
    
    var height: CGFloat {
        self.frame.size.height
    }
    
    var topLeftCornerPoint: CGPoint {
        self.bounds.origin
    }
    
    var bottomRightCornerPoint: CGPoint {
        CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)
    }
    
    var originY: CGFloat {
        self.bounds.minY
    }
    
    func upsideDown() -> Void {
        self.transform = CGAffineTransform(rotationAngle: .pi)
    }
}
