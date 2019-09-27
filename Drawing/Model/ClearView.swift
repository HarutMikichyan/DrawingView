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
    weak var appBackgroundView: UIView? {
        didSet {
            showView()
        }
    }
    
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
    
    func showView() {
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
