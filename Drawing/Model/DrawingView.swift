//
//  DrawingView.swift
//  Drawing
//
//  Created by 1 on 9/20/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

struct PathFragment {
    var identifier: Int = 0
    var path: UIBezierPath
    var color: UIColor
    
    init(path: UIBezierPath, color: UIColor) {
        self.path = path
        self.color = color
        self.identifier = PathFragment.getIdentifier()
    }
    
    static var id = 0
    static func getIdentifier() -> Int {
        id += 1
        return id
    }
}

class DrawingView: UIView {
    enum Mode {
        case clear
        case draw
    }
    
    var undoPaths = [PathFragment]()
    var paths = [PathFragment]()
    var colorSize: CGFloat = 1.0
    var color: UIColor = .black
    var mode: Mode = .draw
    
    private var path = UIBezierPath()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Draw Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        path = UIBezierPath()
        path.lineWidth = colorSize
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        paths.append(PathFragment(path: path, color: (mode == .clear ? self.backgroundColor : color)!))
        
        let touch = touches.first!
        path.move(to: touch.location(in: self))
        setNeedsDisplay()
        undoPaths = []
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        path.addLine(to: touch.location(in: self))
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        path.addLine(to: touch.location(in: self))
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        path.addLine(to: touch.location(in: self))
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for fragment in paths {
            fragment.color.setStroke()
            fragment.path.stroke()
        }
    }
}
