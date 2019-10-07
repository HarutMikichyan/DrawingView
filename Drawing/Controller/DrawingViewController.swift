//
//  ViewController.swift
//  Drawing
//
//  Created by 1 on 9/20/19.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

protocol DrawingViewControllerDelegate: class {
    func getSaveImageInDrawingView(_ image: UIImage)
}

@available(iOS 13.0, *)
class DrawingViewController: UIViewController, AddColorViewDelegate, ClearViewDelegate, DrawingViewDelegate {
    
    var panGesture: UIPanGestureRecognizer!
    var shapeLayerColor: UIColor = .black
    var selectedLayer: ShapeLayerType?
    var backgroundView = UIView()
    var backgroundImage: UIImage = UIImage() {
        didSet {
            guard let _ = drawingImageViewOutlet else { return }
            drawingImageViewOutlet.image = backgroundImage
        }
    }
    
    weak var delegate: DrawingViewControllerDelegate?
    
    //MARK: - Outlets
    @IBOutlet weak var drawingImageViewOutlet: UIImageView!
    @IBOutlet weak var drawingViewOutlet: DrawingView!
    @IBOutlet weak var buttonControlView: UIView!
    @IBOutlet var colorViewOutlet: AddColorView!
    @IBOutlet var clearViewOutlet: ClearView!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        colorViewOutlet.layer.cornerRadius = 5
        clearViewOutlet.layer.cornerRadius = 5
        
        drawingViewOutlet.appDrawingImage = drawingImageViewOutlet
        drawingImageViewOutlet.image = backgroundImage
        drawingViewOutlet.delegate = self
        
        drawingViewOutlet.clipsToBounds = true
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Navigation Bar Hidden
        self.navigationController!.isNavigationBarHidden = true
    }
    
    //MARK: - Top Bar Actions
    @IBAction func popMainViewController(_ sender: UIButton) {
        guard let screenshot = drawingImageViewOutlet.screenshot() else { return }
        delegate?.getSaveImageInDrawingView(screenshot)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func undo(_ sender: UIButton) {
        guard drawingViewOutlet.mode == .draw || drawingViewOutlet.mode == .clear else { return }
        drawingViewOutlet.undoLayer()
    }
    
    @IBAction func redo(_ sender: UIButton) {
        guard drawingViewOutlet.mode == .draw || drawingViewOutlet.mode == .clear else { return }
        drawingViewOutlet.redoLayer()
    }
    
    @IBAction func downloadPhoneImageButtonTapped(_ sender: UIButton) {
        //TODO: input image, drop
    }
    
    @IBAction func drawingImageDownloadButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Would like to save a photo", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (screenshotImage) in
            UIImageWriteToSavedPhotosAlbum(self.drawingImageViewOutlet.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
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

    //MARK: - Bottom Bar Actions
    @IBAction func addPencilColor(_ sender: UIButton) {
        drawingViewOutlet.color = .black
        drawingViewOutlet.mode = .draw
        panGesture.isEnabled = false
        
        addBackgroundView()
        colorViewOutlet.delegate = self
        colorViewOutlet.appBackgroundView = backgroundView
        
        //send data
        colorViewOutlet.colorSizeSlider.value = Float(drawingViewOutlet.colorSize)
        colorViewOutlet.colorSizeLabel.text = "\(Int(drawingViewOutlet.colorSize))"
        colorViewOutlet.colorSizeSlider.thumbTintColor = drawingViewOutlet.color
        colorViewOutlet.colorSizeSlider.tintColor = drawingViewOutlet.color
    }
    
    @IBAction func clearColor(_ sender: UIButton) {
        drawingViewOutlet.mode = .clear
        panGesture.isEnabled = false
        
        addBackgroundView()
        clearViewOutlet.delegate = self
        clearViewOutlet.appBackgroundView = backgroundView
    }
        
    @IBAction func moveTapped(_ sender: UIButton) {
        drawingViewOutlet.mode = .move
        panGesture.isEnabled = true
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let touchLocation = recognizer.location(in: drawingViewOutlet)
            selectLayer(at: touchLocation)
        case .changed:
            guard let layer = selectedLayer else { return }
            let translation = recognizer.translation(in: recognizer.view)
            
            //turn off position animation
            CATransaction.begin();
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            layer.drawLayer.position = CGPoint(x: layer.drawLayer.position.x + translation.x, y: layer.drawLayer.position.y + translation.y)
            drawingViewOutlet.draw(drawingViewOutlet.bounds)
            recognizer.setTranslation(CGPoint.zero, in: drawingViewOutlet)
            CATransaction.commit();
        case .ended:
            guard let selectedLayer = selectedLayer else { return }
            selectedLayer.drawLayer.removeFromSuperlayer()
            drawingImageViewOutlet.layer.addSublayer(selectedLayer.drawLayer)
        default:
            break
        }
    }
    
    //MARK: - AddColorViewDelegate Func
    func getColor(_ color: UIColor, _ colorSize: CGFloat) {
        drawingViewOutlet.color = color
        drawingViewOutlet.colorSize = colorSize
    }
    
    //MARK: - DrawingViewDelegate Func
    func getShapeLayer(_ shapeLayer: CAShapeLayer) {
        drawingImageViewOutlet.layer.addSublayer(shapeLayer)
        drawingViewOutlet.path = UIBezierPath()
    }
    
    func getClearSize(_ size: CGFloat?) {
        if let size = size {
            drawingViewOutlet.mode = .clear
            drawingViewOutlet.colorSize = size
            drawingViewOutlet.color = .white
        } else {
            let _ = drawingViewOutlet.shapeLayers.compactMap({$0.drawLayer.removeFromSuperlayer()})
            drawingViewOutlet.shapeLayers.removeAll()
        }
    }
    
    //MARK: - Private Interface
    private func setupGestures() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
        drawingViewOutlet.addGestureRecognizer(panGesture)
        panGesture.isEnabled = false
    }
    
    private func selectLayer(at loc: CGPoint) {
        let location = drawingImageViewOutlet.layer.convert(loc, to: drawingImageViewOutlet.layer.superlayer)
        let layer = drawingImageViewOutlet.layer.hitTest(location)
        guard let shapeLayer = layer as? ShapeLayer else {
            selectedLayer = nil
            return
        }
        
        shapeLayer.removeFromSuperlayer()
        drawingViewOutlet.layer.addSublayer(shapeLayer)
        shapeLayerColor = UIColor(cgColor: shapeLayer.backgroundColor ?? UIColor.black.cgColor)
        selectedLayer = ShapeLayerType(shapeLayer: shapeLayer, color: shapeLayerColor)
    }
    
    private func addBackgroundView() {
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(backgroundView)
    }
}
 
//MARK: - Extensions
extension UIView {
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        if let image = image { return image }
        return nil
    }
}

extension String {
    func showTextInView(_ labelViewController: UIViewController) {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 24))
        label.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        label.layer.cornerRadius = 7
        label.layer.masksToBounds = true
        label.textColor = .white
        label.center = labelViewController.view.center
        label.textAlignment = NSTextAlignment.center
        label.text = self
        labelViewController.view.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            label.removeFromSuperview()
        }
    }
}
