//
//  SentMemesTableViewController.swift
//  MM1.1PickingAnImage
//
//  Created by Andres Kwan on 1/4/16.
//  Copyright © 2016 Kwan. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    var memes: [Meme]!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        self.tableView.rowHeight = 100
        //1 dequeue/obtain a cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")!
        
        //2 obtain the data for the row
        let meme = memes[indexPath.row]

        //3 add data to the cell
        cell.imageView?.image = meme.memedImage!
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)" as String
        return cell
    }
    
    @IBAction func showMemeEditor(sender: AnyObject) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewControllerWithIdentifier("NavigationForMemeEditor")
        self.presentViewController(memeEditorVC, animated: true, completion: nil)
    }
}
