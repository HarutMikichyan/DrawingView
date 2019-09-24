//
//  ImageTableViewCell.swift
//  Drawing
//
//  Created by 1 on 9/21/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

protocol GetPathsImage: class {
    func moveToTrash(_ paths: [PathFragment], _ index: Int)
    func moveImage(_ imagePaths: [PathFragment])
    func getScreenShot(_ screenImage: UIImage)
}

class ImageTableViewCell: UITableViewCell {
    static let identifier = "ImageTableViewCell"
    
    var indexPath = 0
    weak var delegate: GetPathsImage?
    
    @IBOutlet weak var pathsView: PathsCellView!
    
    override func prepareForReuse() {
        pathsView.paths = []
        pathsView.setNeedsDisplay()
    }
    
    //MARK: - Actions
    @IBAction func undoPathImage(_ sender: UIButton) {
        delegate?.moveImage(pathsView.paths)
    }
    
    @IBAction func moveToTrash(_ sender: UIButton) {
        delegate?.moveToTrash(pathsView.paths, indexPath)
    }
    
    @IBAction func screenshotPathView(_ sender: UIButton) {
        guard let screenshot = pathsView.screenshot() else { return }
        delegate?.getScreenShot(screenshot)
    }
}

extension UIView {
    func screenshot() -> UIImage? {
        //begin
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        //draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        //get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            return image!
        }
        return nil
    }
}

