//
//  ViewController.swift
//  Drawing
//
//  Created by 1 on 9/20/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, GetColorDelegate, GetClearSizeDelegate {
    static var backgroundView = UIView()
    
    var movePaths = [PathFragment]()
    var pathsArray = [[PathFragment]]()
    
    //MARK: - Outlets
    @IBOutlet var colorViewOutlet: AddColorView!
    @IBOutlet var clearViewOutlet: ClearView!
    @IBOutlet weak var drawingView: DrawingView! {
        didSet {
            //move paths
            if !movePaths.isEmpty {
                drawingView.paths = movePaths
                drawingView.setNeedsDisplay()
                movePaths = []
            }
        }
    }
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        colorViewOutlet.layer.cornerRadius = 5
        clearViewOutlet.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Navigation Bar Hidden
        self.navigationController?.isNavigationBarHidden = true
    }

    //MARK: - Actions
    @IBAction func addPencilColor(_ sender: UIButton) {
        drawingView.mode = .draw
        showView(colorViewOutlet)
        
        colorViewOutlet.delegate = self
        //send data
        colorViewOutlet.colorSizeSlider.value = Float(drawingView.colorSize)
        colorViewOutlet.colorSizeLabel.text = "\(Int(drawingView.colorSize))"
        colorViewOutlet.colorSizeSlider.thumbTintColor = drawingView.color
        colorViewOutlet.colorSizeSlider.tintColor = drawingView.color
    }
    
    @IBAction func clearColor(_ sender: UIButton) {
        drawingView.mode = .clear
        showView(clearViewOutlet)
        
        clearViewOutlet.delegate = self
    }
    
    @IBAction func undo(_ sender: UIButton) {
        guard !drawingView.paths.isEmpty else { return }
        drawingView.undoPaths.append(drawingView.paths.removeLast())
        drawingView.setNeedsDisplay()
    }
    
    @IBAction func redo(_ sender: UIButton) {
        guard !drawingView.undoPaths.isEmpty else { return }
        drawingView.paths.append(drawingView.undoPaths.removeLast())
        drawingView.setNeedsDisplay()
    }
    
    @IBAction func addImageList(_ sender: UIButton) {
        if drawingView.paths.isEmpty {
            let alert = UIAlertController(title: "Drawing View Is Empty", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            self.pathsArray.append(self.drawingView.paths)
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.backgroundColor = .black
            label.textColor = .white
            label.center = self.view.center
            label.textAlignment = NSTextAlignment.center
            label.text = "Appended To Image List"
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
    
    @IBAction func showImageList(_ sender: UIButton) {
        if !pathsArray.isEmpty {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageListViewControllerID") as? ImageListViewController
            vc?.pathsArray = pathsArray
            vc?.superViewController = self
            navigationController?.pushViewController(vc!, animated: true)
        } else {
            let ac = UIAlertController(title: "Image List Is Empty", message: "", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(ac, animated: true)
        }
    }
    
    //MARK: - GetColorDelegate Func
    func getColor(_ color: UIColor, _ colorSize: CGFloat) {
        drawingView.color = color
        drawingView.colorSize = colorSize
    }
    
    //MARK: - GetClearSizeDelegate Func
    func getClearSize(_ size: CGFloat) {
        drawingView.colorSize = size
    }
    
    func erase() {
        drawingView.paths.removeAll()
        drawingView.setNeedsDisplay()
    }
    
    //MARK: - Private Interface
    private func showView(_ view: UIView) {
        DrawingViewController.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(DrawingViewController.backgroundView)
        DrawingViewController.backgroundView.addSubview(view)
        view.center = DrawingViewController.backgroundView.center
        
        DrawingViewController.backgroundView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        DrawingViewController.backgroundView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            DrawingViewController.backgroundView.alpha = 1
            DrawingViewController.backgroundView.transform = CGAffineTransform.identity
        }
    }
    
    private func closeView() {
        UIView.animate(withDuration: 0.3, animations: {
            DrawingViewController.backgroundView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            DrawingViewController.backgroundView.alpha = 0
        }) { (success: Bool) in
            DrawingViewController.backgroundView.removeFromSuperview()
        }
    }
}
