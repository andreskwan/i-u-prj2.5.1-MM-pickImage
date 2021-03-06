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
    @IBOutlet weak var subView: UIView!
    
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
        var isAllowedToSaveMeme: Bool?
        // edit a meme
        if let _ = meme {//Edit meme
            configureTextfield(topTextField, text: meme.topText! as String)
            configureTextfield(bottomTextfield, text: meme.bottomText! as String)
            imagePickerView.image = meme.image
            isAllowedToSaveMeme = true
        } else { //Create new meme
            configureTextfield(topTextField, text: "TOP")
            configureTextfield(bottomTextfield, text: "BOTTOM")
            imagePickerView.image = nil
            isAllowedToSaveMeme = false
        }
        // allow to save/share edited meme
        actionButton.enabled = isAllowedToSaveMeme!
    }
    
    // MARK: IBActions
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        presentImagePickerControllerWithSourceType(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        presentImagePickerControllerWithSourceType(UIImagePickerControllerSourceType.Camera)
    }
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func displayActivityVC(sender: UIBarButtonItem) {
        generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activity, success, items, error) in
            if(success){
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
//            activityVC.popoverPresentationController?.barButtonItem = actionButton
                let rect = CGRect(x: 50, y: 50, width: 150, height: 150)
                activityVC.popoverPresentationController?.sourceRect = rect
                activityVC.popoverPresentationController?.sourceView = view
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
        let viewBackgroundColor = view.backgroundColor
        let subViewBackgroundColor = subView.backgroundColor
        view.backgroundColor = UIColor.clearColor()
        subView.backgroundColor = UIColor.clearColor()
        let subviewFrameSize = subView.frame.size
        UIGraphicsBeginImageContext(subviewFrameSize)
        subView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let nsdata = UIImagePNGRepresentation(memedImage)
        memedImage = UIImage.init(data: nsdata!)
        hideBars(false)
        view.backgroundColor = viewBackgroundColor
        subView.backgroundColor = subViewBackgroundColor
    }
    func hideBars(shouldHideBars:Bool)
    {
        topToolBar.hidden = shouldHideBars
        bottomToolBar.hidden = shouldHideBars
    }

    // MARK: Helpers
    func configureTextfield(textField: UITextField, text:String) {
        textField.text = text as String
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        textField.textAlignment = NSTextAlignment.Center
        textField.delegate = self
    }
    
    func presentImagePickerControllerWithSourceType(pickerSourceType:UIImagePickerControllerSourceType) {
        initializeMeme()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = pickerSourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}