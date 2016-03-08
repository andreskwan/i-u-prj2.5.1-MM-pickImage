//
//  ViewController.swift
//  MM1.1PickingAnImage
//
//  Created by Andres Kwan on 9/28/15.
//  Copyright (c) 2015 Kwan. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    var keyBoardHeight: CGFloat!
    var shouldHideBars: Bool!
    var memedImage: UIImage!
    var meme: Meme!
    var memeIndex: Int!
    
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
        //enable if the device has a camera
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
        var allowSave: Bool?
        // edit a meme
        if let _ = meme {
            topTextField.text = meme.topText! as String
            bottomTextfield.text = meme.bottomText! as String
            imagePickerView.image = meme.image
            allowSave = true
        } else { //Create new meme
            topTextField.text = "TOP"
            bottomTextfield.text = "BOTTOM"
            imagePickerView.image = nil
            allowSave = false
        }
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.delegate = self
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomTextfield.textAlignment = NSTextAlignment.Center
        bottomTextfield.delegate = self
        // allow to save/share edited meme
        actionButton.enabled = allowSave!
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
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
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
    
    // MARK: Meme Model - methods
    func save() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextfield.text!, image: imagePickerView.image!, memedImage: memedImage)
        if let _ = memeIndex {
            appDelegate.memes[memeIndex] = meme
        } else {
            appDelegate.memes.append(meme)
        }
    }
    func generateMemedImage() {
        hideBars(true)
        let backgroundColor = view.backgroundColor
        view.backgroundColor = UIColor.clearColor()
        let frameSize = self.view.frame.size
        UIGraphicsBeginImageContext(frameSize)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let nsdata = UIImagePNGRepresentation(memedImage)
        memedImage = UIImage.init(data: nsdata!)
        hideBars(false)
        view.backgroundColor = backgroundColor
    }
    func hideBars(shouldHideBars:Bool)
    {
        topToolBar.hidden = shouldHideBars
        bottomToolBar.hidden = shouldHideBars
    }
}