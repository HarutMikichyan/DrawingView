//
//  DrawingView.swift
//  Drawing
//
//  Created by 1 on 9/20/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

protocol DrawingViewDelegate: class {
    func getShapeLayer(_ shapeLayer: CAShapeLayer)
}

struct ShapeLayerType {
    var drawLayer: CAShapeLayer
    var color: UIColor
    
    init(shapeLayer: CAShapeLayer, color: UIColor) {
        self.drawLayer = shapeLayer
        self.color = color
    }
}

class ShapeLayer: CAShapeLayer {
    override func contains(_ p: CGPoint) -> Bool {
        return path?.contains(p, using: .winding, transform: .identity) ?? false
    }
}

class DrawingView: UIView {
    enum Mode {
        case clear
        case draw
        case move
    }
    
    unowned var delegate: DrawingViewDelegate?
    unowned var appDrawingImage: UIImageView?
    
    private var undoLayers = [ShapeLayerType]()
    private var shapeLayer: CAShapeLayer!
    
    var shapeLayers = [ShapeLayerType]()
    var colorSize: CGFloat = 1.0
    var color: UIColor = .black
    var path = UIBezierPath()
    var mode: Mode = .draw
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Draw Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .draw || mode == .clear {
            path = UIBezierPath()
            path.lineWidth = colorSize
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            let touch = touches.first!
            path.move(to: touch.location(in: self))
            undoLayers = []
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .draw || mode == .clear {
            let touch = touches.first!
            path.addLine(to: touch.location(in: self))
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .draw || mode == .clear {
            let touch = touches.first!
            path.addLine(to: touch.location(in: self))
            touchEnded()
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .draw || mode == .clear {
            let touch = touches.first!
            path.addLine(to: touch.location(in: self))
            touchEnded()
        }
        setNeedsDisplay()
    }
    
    func touchEnded() {
        shapeLayer = ShapeLayer()
        shapeLayer.frame = path.bounds
        path.apply(CGAffineTransform(translationX: -path.bounds.origin.x, y: -path.bounds.origin.y))
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.opacity = 1
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        
        shapeLayers.append(ShapeLayerType(shapeLayer: shapeLayer, color: color))
        delegate?.getShapeLayer(shapeLayer)
        path.removeAllPoints()
        setNeedsDisplay()
    }
    
    func undoLayer() {
        guard !shapeLayers.isEmpty, let lastIndex = appDrawingImage!.layer.sublayers?.count else { return }
        
        appDrawingImage!.layer.sublayers?.remove(at: lastIndex - 1)
        undoLayers.append(shapeLayers.removeLast())
        path = UIBezierPath()
        setNeedsDisplay()
    }
    
    func redoLayer() {
        guard !undoLayers.isEmpty else { return }
        
        shapeLayers.append(undoLayers.removeLast())
        appDrawingImage!.layer.addSublayer(shapeLayers.last!.drawLayer)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if mode == .draw || mode == .clear {
            color.setStroke()
            path.stroke()
        }
    }
}
