//
//  AddColorView.swift
//  Drawing
//
//  Created by 1 on 9/20/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

protocol AddColorViewDelegate: class {
    func getColor(_ color: UIColor, _ colorSize: CGFloat)
}

class AddColorView: UIView {
    
    weak var delegate: AddColorViewDelegate?
    weak var appBackgroundView: UIView? {
        didSet {
            showView()
        }
    }

    @IBOutlet weak var colorSizeLabel: UILabel!
    @IBOutlet weak var colorSizeSlider: UISlider!
    @IBOutlet weak var colorBackgroundView: UIView!
    @IBOutlet weak var customColorView: UIView!
    @IBOutlet weak var colorStackOutlet: UIStackView!
    @IBOutlet weak var customButtonOutlet: UIButton!
    //Custom Color View Outlet
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    
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
        var red: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var green: CGFloat = 0.0
        sender.backgroundColor?.getRed(&red, green: &green, blue: &blue, alpha: nil)
        redLabel.text = "\(Int(red * 255))"
        blueLabel.text = "\(Int(blue * 255))"
        greenLabel.text = "\(Int(green * 255))"
        redSlider.value = Float(red * 255)
        blueSlider.value = Float(blue * 255)
        greenSlider.value = Float(green * 255)
    }
    
    @IBAction func changeColorView(_ sender: UIButton) {
        if sender.currentTitle == "Custom" {
            customButtonOutlet.setTitle("Normal", for: .normal)
            colorStackOutlet.isHidden = true
            colorBackgroundView.addSubview(customColorView)
            customColorView.center = colorBackgroundView.center
            customColorView.translatesAutoresizingMaskIntoConstraints = false
            
            customColorView.topAnchor.constraint(equalTo: colorBackgroundView.topAnchor, constant: 0).isActive = true
            customColorView.leadingAnchor.constraint(equalTo: colorBackgroundView.leadingAnchor, constant: 0).isActive = true
            customColorView.trailingAnchor.constraint(equalTo: colorBackgroundView.trailingAnchor, constant: 0).isActive = true
            customColorView.bottomAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor, constant: 0).isActive = true
        } else {
            customButtonOutlet.setTitle("Custom", for: .normal)
            customColorView.removeFromSuperview()
            colorStackOutlet.isHidden = false
        }
    }
    
    //MARK: Custom View Methods
    @IBAction func changeColorSlider(_ sender: UISlider) {
        redLabel.text = "\(Int(redSlider.value))"
        blueLabel.text = "\(Int(blueSlider.value))"
        greenLabel.text = "\(Int(greenSlider.value))"
        changeColor()
    }
    
    private func changeColor() {
        let color = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 1)
        colorSizeSlider.thumbTintColor = color
        colorSizeSlider.tintColor = color
    }
    
    private func showView() {
        appBackgroundView!.addSubview(self)
        self.center = appBackgroundView!.center
        
        self.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
    }
    
    //MARK: - Private Interface
    private func closeView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.appBackgroundView!.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.appBackgroundView!.alpha = 0
        }) { (success: Bool) in
            self.appBackgroundView!.removeFromSuperview()
        }
    }
}
