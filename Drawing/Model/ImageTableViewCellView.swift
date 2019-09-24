//
//  ImageTableViewCellView.swift
//  Drawing
//
//  Created by 1 on 9/21/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

class ImageCellView: UIView {

    var paths = [PathFragment]()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        for fragment in paths {
            fragment.color.setStroke()
            fragment.path.stroke()
        }
        setNeedsLayout()
        setNeedsDisplay()
    }
}
