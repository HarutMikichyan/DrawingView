//
//  SaveImageCollectionViewCell.swift
//  Drawing
//
//  Created by Harut Mikichyan on 10/4/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate: class {
    func imageButtonTapped(_ indexPath: Int, _ moveBool: Bool, _ deleteBool: Bool, _ saveBool: Bool)
}

class SaveImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "SaveImageCollectionViewCell"
    
    weak var delegate: CollectionViewCellDelegate?
    var indexPath: Int = 0
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            delegate?.imageButtonTapped(indexPath, true, false, false)
        case 1:
            delegate?.imageButtonTapped(indexPath, false, true, false)
        default:
            delegate?.imageButtonTapped(indexPath, false, false, true)
        }
    }
}
