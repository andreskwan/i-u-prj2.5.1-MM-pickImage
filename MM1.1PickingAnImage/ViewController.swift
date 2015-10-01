//
//  ViewController.swift
//  MM1.1PickingAnImage
//
//  Created by Andres Kwan on 9/28/15.
//  Copyright (c) 2015 Kwan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    var keyBoardHeight: CGFloat!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: -3.0,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.unsubscribeFromKeyBoardNotifications() 
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: IBActions
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate - methods
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
                self.animateTextField(true)
            }
        }
    }
    func animateTextField(up: Bool) {
        let movement = (up ? -keyBoardHeight : keyBoardHeight)
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextfield.isFirstResponder() {
            self.animateTextField(false)
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
    
    // MARK: Meme Model
    func save() -> Meme {
        let memedImage = generateMemedImage()
        return Meme(topText: topTextField.text!, bottomText: bottomTextfield.text!, image: imagePickerView.image!, memedImage: memedImage)
    }
    func generateMemedImage() ->UIImage {
        //1 render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    // MARK:
    @IBAction func displayActivityVC(sender: UIBarButtonItem) {
        let meme = save()
        let activityVC = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    
}