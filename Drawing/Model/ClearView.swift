//
//  ClearView.swift
//  Drawing
//
//  Created by 1 on 9/20/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

protocol GetClearSizeDelegate: class {
    func getClearSize(_ size: CGFloat)
    func erase()
}

class ClearView: UIView {
    
    weak var delegate: GetClearSizeDelegate?
    
    @IBOutlet weak var clearSizeLabel: UILabel!
    @IBOutlet weak var clearSizeSlider: UISlider!
    
    //MARK: - Actions
    @IBAction func close(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Done":
            delegate?.getClearSize(CGFloat(clearSizeSlider.value))
        default:
            break
        }
        
        closeView()
    }
    
    @IBAction func clearSizeChange(_ sender: UISlider) {
        clearSizeLabel.text = "\(Int(sender.value))"
    }
    
    
    @IBAction func erase(_ sender: UIButton) {
        delegate?.erase()
        closeView()
    }
    
    //MARK: - Private Interface
    private func closeView() {
        UIView.animate(withDuration: 0.3, animations: {
            DrawingViewController.backgroundView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            DrawingViewController.backgroundView.alpha = 0
        }) { (success: Bool) in
            DrawingViewController.backgroundView.removeFromSuperview()
        }
    }
}
