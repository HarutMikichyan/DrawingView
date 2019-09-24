//
//  AddColorView.swift
//  Drawing
//
//  Created by 1 on 9/20/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

protocol GetColorDelegate: class {
    func getColor(_ color: UIColor, _ colorSize: CGFloat)
}

class AddColorView: UIView {
    
    weak var delegate: GetColorDelegate?

    @IBOutlet weak var colorSizeLabel: UILabel!
    @IBOutlet weak var colorSizeSlider: UISlider!
    
    //MARK: - Actions
    @IBAction func lineWidthChange(_ sender: UISlider) {
        colorSizeLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func closeViewButtons(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Done":
            delegate?.getColor(colorSizeSlider.tintColor, CGFloat(colorSizeSlider.value))
        default:
            break
        }
        
        //animate
        UIView.animate(withDuration: 0.3, animations: {
            DrawingViewController.backgroundView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            DrawingViewController.backgroundView.alpha = 0
        }) { (success: Bool) in
            DrawingViewController.backgroundView.removeFromSuperview()
        }
    }
    
    @IBAction func chooseColor(_ sender: UIButton) {
        colorSizeSlider.thumbTintColor = sender.backgroundColor
        colorSizeSlider.tintColor = sender.backgroundColor
    }
}
