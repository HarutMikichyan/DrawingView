//
//  PathsCellView.swift
//  Drawing
//
//  Created by 1 on 9/27/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

class PathsCellView: UIView {

    var paths = [PathFragment]()
    
    override func draw(_ rect: CGRect) {
        for fragment in paths {
            fragment.color.setStroke()
            fragment.path.stroke()
        }
    }

}
