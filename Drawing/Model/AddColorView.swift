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
    var appBackgroundView: UIView!

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
        
        closeView()
    }
    
    @IBAction func chooseColor(_ sender: UIButton) {
        colorSizeSlider.thumbTintColor = sender.backgroundColor
        colorSizeSlider.tintColor = sender.backgroundColor
    }
    
    func showView(_ superView: UIView) {
        appBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: superView.bounds.width, height: superView.bounds.height))
        superView.addSubview(appBackgroundView)
        appBackgroundView.addSubview(self)
        self.center = appBackgroundView.center
        
        appBackgroundView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        appBackgroundView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.appBackgroundView.alpha = 1
            self.appBackgroundView.transform = CGAffineTransform.identity
        }
    }
    
    //MARK: - Private Interface
    private func closeView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.appBackgroundView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.appBackgroundView.alpha = 0
        }) { (success: Bool) in
            self.appBackgroundView.removeFromSuperview()
        }
    }
}
