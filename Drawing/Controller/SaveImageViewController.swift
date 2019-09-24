//
//  SaveImageViewController.swift
//  Drawing
//
//  Created by 1 on 9/21/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController, GetPathsImage {
    
    var pathsArray = [[PathFragment]]()
    var superViewController = DrawingViewController()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register
        tableView.register(UINib(nibName: ImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ImageTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Delegate Func
    func getScreenShot(_ screenImage: UIImage) {
        let alertController = UIAlertController(title: "Screenshot image", message: "Would like to save a photo", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (screenshotImage) in
            UIImageWriteToSavedPhotosAlbum(screenImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
        } else {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 21))
            label.backgroundColor = .black
            label.textColor = .white
            label.center = self.view.center
            label.textAlignment = NSTextAlignment.center
            label.text = "Image Save"
            self.view.addSubview(label)
            
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { [weak self] (timer) in
                guard let _ = self else {
                    timer.invalidate()
                    return
                }
                label.removeFromSuperview()
            }
        }
    }
    
    func undoImage(_ screenImage: [PathFragment]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DrawingViewControllerID") as! DrawingViewController
        vc.undoPaths = screenImage
        vc.pathsArray = self.pathsArray
        navigationController?.viewControllers = [vc, self]
        navigationController?.popViewController(animated: true)
    }
    
    func moveToTrash(_ cell: UITableViewCell, _ index: Int) {
        superViewController.pathsArray.remove(at: index)
        pathsArray.remove(at: index)
        if pathsArray.isEmpty {
            navigationController?.popViewController(animated: true)
        } else {
            let indexPath = IndexPath(item: index, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ImageListViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - UITabelView Delegate DataSource
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 1.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pathsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
        cell.pathsView.paths = pathsArray[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath.row
        return cell
    }
}
