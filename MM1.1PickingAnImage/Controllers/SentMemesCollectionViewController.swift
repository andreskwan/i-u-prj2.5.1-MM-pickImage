//
//  SentMemesCollectionViewController.swift
//  MM1.1PickingAnImage
//
//  Created by Andres Kwan on 1/4/16.
//  Copyright © 2016 Kwan. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    var memes: [Meme]!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: -3.0,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.reloadData()
    }
    
    // MARK: IBActions
    @IBAction func showMemeEditor(sender: AnyObject) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as! EditorViewController
        //TODO: present modally or Master-Detail?
        self.presentViewController(memeEditorVC, animated: true, completion: nil)
    }
    
    // MARK: CollectionView - DataSource Methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! SentMemeCollectionViewCell
        let meme = memes[indexPath.item]
        

        cell.topTextField.defaultTextAttributes = memeTextAttributes
        cell.topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        cell.topTextField.textAlignment = NSTextAlignment.Center
        cell.topTextField.delegate = self
        
        cell.bottomTextField.defaultTextAttributes = memeTextAttributes
        cell.bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        cell.bottomTextField.textAlignment = NSTextAlignment.Center
        cell.bottomTextField.delegate = self
        
        cell.memeImage.image = meme.image!
        cell.topTextField.text = meme.topText as String
        cell.bottomTextField.text = meme.bottomText as String

        return cell
    }
    
    // MARK: CollectionView - Delegate Methods
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        let meme = memes[indexPath.item]

        detailVC.meme = meme 
        detailVC.memeIndex = indexPath.row
        
        self.navigationController!.pushViewController(detailVC, animated: true)
        
    }

    // MARK: TextField - Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }    
}
