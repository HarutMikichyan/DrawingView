//
//  MainViewController.swift
//  Drawing
//
//  Created by Harut Mikichyan on 10/4/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class MainViewController: UIViewController, DrawingViewControllerDelegate, CollectionViewCellDelegate {
    
    var shapeLayerImages = [UIImage]() {
        didSet {
            if shapeLayerImages.isEmpty {
                startView.isHidden = false
            } else {
                startView.isHidden = true
            }
        }
    }
    
    //MARK: - Outlets
    @IBOutlet var startView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //register
        collectionView.register(UINib(nibName: SaveImageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SaveImageCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startViewConstreint()
        //Navigation Bar Hidden
        self.navigationController!.isNavigationBarHidden = true
    }
    
    //MARK: - Actions
    @IBAction func pushDrawingViewController(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "DrawingViewControllerID") as! DrawingViewController
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - DrawingViewControllerDelegate Func
    func getSaveImageInDrawingView(_ image: UIImage) {
        shapeLayerImages.append(image)
        collectionView.reloadData()
    }
    
    //MARK: - CollectionViewCellDelegate Func
    func imageButtonTapped(_ indexPath: Int, _ moveBool: Bool, _ deleteBool: Bool, _ saveBool: Bool) {
        if moveBool {
            let vc = storyboard?.instantiateViewController(identifier: "DrawingViewControllerID") as! DrawingViewController
            vc.delegate = self
            vc.backgroundImage = shapeLayerImages[indexPath]
            navigationController?.pushViewController(vc, animated: true)
        } else if deleteBool {
            shapeLayerImages.remove(at: indexPath)
            collectionView.reloadData()
        } else if saveBool {
            saveImage(self.shapeLayerImages[indexPath])
        }
    }
    
    //MARK: - Private Interface
    private func startViewConstreint() {
        view.addSubview(startView)
        startView.translatesAutoresizingMaskIntoConstraints = false
        
        startView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(0)).isActive = true
        startView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(0)).isActive = true
        startView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(0)).isActive = true
        startView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(0)).isActive = true
    }
    
    private func saveImage(_ image: UIImage) {
        let alertController = UIAlertController(title: "", message: "Would like to save a photo", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (screenshotImage) in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(ac, animated: true, completion: nil)
        } else {
            let showText = "Image Saved"
            showText.showTextInView(self)
        }
    }
}

//MARK: - CollectionView Delegate DataSource
@available(iOS 13.0, *)
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shapeLayerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SaveImageCollectionViewCell.identifier, for: indexPath) as! SaveImageCollectionViewCell
        cell.imageViewOutlet.image = shapeLayerImages[indexPath.row]
        cell.indexPath = indexPath.row
        cell.delegate = self
        return cell
    }
}
