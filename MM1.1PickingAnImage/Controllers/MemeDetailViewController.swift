//
//  MemeDetailViewController.swift
//  MM1.1PickingAnImage
//
//  Created by Andres Kwan on 1/12/16.
//  Copyright © 2016 Kwan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme?
    var memeIndex: Int?
    
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(MemeDetailViewController.showMemeEditor))
        memeImage.image = meme?.memedImage
        navigationItem.rightBarButtonItem = editButton        
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
        super.viewWillDisappear(true)
    }
    
    // MARK: IBActions
    func showMemeEditor() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let editorVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as! EditorViewController
        editorVC.meme = meme
        editorVC.memeIndex = memeIndex
        //To present editorVC
        presentViewController(editorVC, animated: true, completion: nil)
        //To remove itself from the navigationController stack
        //when EditorVC-cancel buttom is tapped the top VC in the navigationController is presented
        navigationController!.popViewControllerAnimated(true)
    }
}
