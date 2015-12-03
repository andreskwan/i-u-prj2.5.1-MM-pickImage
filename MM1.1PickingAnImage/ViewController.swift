//
//  ViewController.swift
//  MM1.1PickingAnImage
//
//  Created by Andres Kwan on 9/28/15.
//  Copyright (c) 2015 Kwan. All rights reserved.
//

import UIKit
import imglyKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var subviewTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var subviewBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var topTextFieldConstrain: NSLayoutConstraint!
    @IBOutlet weak var bottomTextFieldConstrain: NSLayoutConstraint!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    var keyBoardHeight: CGFloat!
    var shouldHideBars: Bool!
    var memedImage: UIImage!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: -3.0,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMeme()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyBoardNotifications() 
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func initializeMeme(){
        shouldHideBars = false
        toggleBars()
        
        topTextField.text = "TOP"
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.delegate = self
        
        bottomTextfield.text = "BOTTOM"
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomTextfield.textAlignment = NSTextAlignment.Center
        bottomTextfield.delegate = self
        
        actionButton.enabled = false
        imagePickerView.image = nil
    }
    
    // MARK: IBActions
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        initializeMeme()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        initializeMeme()
//        let cameraViewController = IMGLYCameraViewController(recordingModes: [.Photo, .Video])
//        presentViewController(cameraViewController, animated: true, completion: nil)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func cancelButton(sender: AnyObject) {
        initializeMeme()
    }
    @IBAction func displayActivityVC(sender: UIBarButtonItem) {
        generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activity, success, items, error) in
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate - methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            actionButton.enabled = true
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            showEditorNavigationControllerWithImage(image)
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: IMGLY editor
//    func showEditorNavigationControllerWithImage(image: UIImage) {
//        let editorViewController = IMGLYMainEditorViewController()
//        editorViewController.highResolutionImage = image
////        if let cameraController = cameraController {
////            editorViewController.initialFilterType = cameraController.effectFilter.filterType
////            editorViewController.initialFilterIntensity = cameraController.effectFilter.inputIntensity
////        }
//        editorViewController.completionBlock = editorCompletionBlock
//        
////        let navigationController = IMGLYNavigationController(rootViewController: editorViewController)
////        navigationController.navigationBar.barStyle = .Black
////        navigationController.navigationBar.translucent = false
////        navigationController.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor() ]
//        
//        self.presentViewController(editorViewController, animated: true, completion: nil)
//    }

    
    func showEditorNavigationControllerWithImage(image: UIImage) {
        let storyboar = UIStoryboard(name: "Main", bundle: nil)
        let editorViewController = storyboar.instantiateViewControllerWithIdentifier("MainEditor") as! IMGLYMainEditorViewController
        editorViewController.highResolutionImage = image
        editorViewController.initialFilterType = .None
        editorViewController.initialFilterIntensity = 0.5
        editorViewController.completionBlock = editorCompletionBlock
        self.presentViewController(editorViewController, animated: true, completion: nil)
    }
    
    private func editorCompletionBlock(result: IMGLYEditorResult, image: UIImage?) {
        if let image = image where result == .Done {
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate - Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.text?.isEmpty == true) {
            if textField == topTextField {
                topTextField.text = "TOP"
            }
            else {
                bottomTextfield.text = "BOTTOM"
            }
        }
    }

    // MARK: Keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyBoardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextfield.isFirstResponder() {
            keyBoardHeight = getKeyboardHeight(notification)
            if keyBoardHeight != 0 {
                animateTextField(true)
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextfield.isFirstResponder() && keyBoardHeight != nil {
            animateTextField(false)
        }
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                return keyboardSize.height
            }
        }
        return 0
    }
    func animateTextField(up: Bool) {
        let movement = (up ? -keyBoardHeight : keyBoardHeight)
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    
    // MARK: Meme Model
    func save() -> Meme {
        return Meme(topText: topTextField.text!, bottomText: bottomTextfield.text!, image: imagePickerView.image!, memedImage: memedImage)
    }
    func generateMemedImage() {
        toggleBars()
        UIGraphicsBeginImageContext(self.subView.frame.size)
        self.view.drawViewHierarchyInRect(self.subView.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toggleBars()
    }
    
    // MARK: Tap Gesture
    func toggleBars()
    {
        self.navigationController?.setNavigationBarHidden(shouldHideBars, animated: false)
        self.navigationController?.setToolbarHidden(shouldHideBars, animated: false)
        if shouldHideBars != false{
            subviewTopConstrain.constant = 0
            subviewBottomConstrain.constant = 0
        }
        shouldHideBars = !shouldHideBars
    }
}