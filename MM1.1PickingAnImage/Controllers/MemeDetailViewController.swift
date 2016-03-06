//
//  MemeDetailViewController.swift
//  MM1.1PickingAnImage
//
//  Created by Andres Kwan on 1/12/16.
//  Copyright © 2016 Kwan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var image: UIImage?
    var meme: Meme?
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        super.viewWillAppear(true)
        memeImage.image = meme?.memedImage
        navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        super.viewWillDisappear(true)
    }
    
    // MARK: IBActions
    @IBAction func showMemeEditor(sender: AnyObject) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let editorVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as! EditorViewController
        editorVC.meme = meme
        
//        self.navigationController!.pushViewController(editorVC, animated: true)
        self.presentViewController(editorVC, animated: true, completion: nil)
        navigationController!.popViewControllerAnimated(true)
    }

}
