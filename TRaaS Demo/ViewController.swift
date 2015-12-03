//
//  ViewController.swift
//  TRaaS Demo
//
//  Created by Varatep Buranintu on 12/1/15.
//  Dragos Guta
//  Copyright © 2015 dgvb. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var findTextField: UITextField!
    @IBOutlet weak var replaceTextField: UITextField!
//    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    var activityIndicator:UIActivityIndicatorView!
    var originalTopMargin:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        originalTopMargin = topMarginConstraint.constant
    }
    
    @IBAction func sendToServer(sender: AnyObject) {
        
    }
    func performImageRecognition(image: UIImage) {
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        tesseract.engineMode = .TesseractCubeCombined
        tesseract.pageSegmentationMode = .Auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        textView.text = tesseract.recognizedText
        textView.editable = true
        removeActivityIndicator()
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        view.endEditing(true)
//        moveViewDown()
        
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
            message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                style: .Default) { (alert) -> Void in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .Camera
                    self.presentViewController(imagePicker,
                        animated: true,
                        completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(title: "Choose Existing",
            style: .Default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker,
                    animated: true,
                    completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        let cancelButton = UIAlertAction(title: "Cancel",
            style: .Cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        
        presentViewController(imagePickerActionSheet, animated: true,
            completion: nil)
    }
    
    @IBAction func swapText(sender: AnyObject) {
        if textView.text.isEmpty {
            return
        }
        
        textView.text =
            textView.text.stringByReplacingOccurrencesOfString(findTextField.text!,
                withString: replaceTextField.text!, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        findTextField.text = nil
        replaceTextField.text = nil
        
        view.endEditing(true)
//        moveViewDown()
    }
    
    @IBAction func sharePoem(sender: AnyObject) {
        
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
//    func moveViewUp() {
//        if topMarginConstraint.constant != originalTopMargin {
//            return
//        }
//        
//        topMarginConstraint.constant -= 135
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        })
//    }
//    
//    func moveViewDown() {
//        if topMarginConstraint.constant == originalTopMargin {
//            return
//        }
//        
//        topMarginConstraint.constant = originalTopMargin
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        })
//        
//    }
    
    @IBAction func backgroundTapped(sender: AnyObject) {
        view.endEditing(true)
//        moveViewDown()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
//        moveViewUp()
    }
    
    @IBAction func textFieldEndEditing(sender: AnyObject) {
        view.endEditing(true)
//        moveViewDown()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
//        moveViewDown()
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
            let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
            
            addActivityIndicator()
            
            dismissViewControllerAnimated(true, completion: {
                self.performImageRecognition(scaledImage)
            })
    }
}


