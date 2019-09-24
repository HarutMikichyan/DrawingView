//
//  ImageListViewController.swift
//  Drawing
//
//  Created by 1 on 9/23/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController, GetPathsImage {
    
    var pathsArray = [[PathFragment]]()
    var superViewController = DrawingViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cycle Methods
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
    
    func moveImage(_ screenImage: [PathFragment]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DrawingViewControllerID") as! DrawingViewController
        vc.movePaths = screenImage
        vc.pathsArray = self.pathsArray
        navigationController?.viewControllers = [vc, self]
        navigationController?.popViewController(animated: true)
    }
    
    func moveToTrash(_ paths: [PathFragment], _ index: Int) {
        let imageIdentifier = paths.compactMap{$0.identifier}.reduce(0, +)
        PathFragment.id = 0
        for i in 0..<pathsArray.count {
            let pathsArr = pathsArray[i]
            let pathsIdentifier = pathsArr.compactMap{$0.identifier}.reduce(0, +)
            if imageIdentifier == pathsIdentifier {
                pathsArray.remove(at: i)
                superViewController.pathsArray.remove(at: i)

                if pathsArray.isEmpty {
                    navigationController?.popViewController(animated: true)
                } else {
                    let indexPath = IndexPath(item: index, section: 0)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    break
                }
            }
        }
    }
}

//MARK: - UITableView Delegate DataSource
extension ImageListViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("kjgl")
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 1.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pathsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell else { return UITableViewCell(style: .default, reuseIdentifier: ImageTableViewCell.identifier)
        }
        
        cell.selectionStyle = .none
        cell.pathsView.paths = pathsArray[indexPath.row]
        cell.indexPath = indexPath.row
        cell.delegate = self
        return cell
    }
}
