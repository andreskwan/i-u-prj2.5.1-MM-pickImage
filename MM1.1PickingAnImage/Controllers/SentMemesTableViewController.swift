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
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }
    // MARK: IBActions
    @IBAction func showMemeEditor(sender: AnyObject) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as! EditorViewController
        self.presentViewController(memeEditorVC, animated: true, completion: nil)
    }
    
    // MARK: TableView - DataSource Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //TODO: use a constant instead a hardcode number
        self.tableView.rowHeight = 100
        //1 dequeue/obtain a cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")! as! SentMemesTableViewCell
        
        //2 obtain the data for the row
        let meme = memes[indexPath.row]
        
        //3 add data to the cell
        cell.topTextField.defaultTextAttributes = memeTextAttributes
        cell.topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        cell.topTextField.textAlignment = NSTextAlignment.Center
        cell.bottomTextField.defaultTextAttributes = memeTextAttributes
        cell.bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        cell.bottomTextField.textAlignment = NSTextAlignment.Center

        cell.memeImageView.image = meme.image!
        cell.topTextField.text = meme.topText as String
        cell.bottomTextField.text = meme.bottomText as String
        cell.memeMessageLabel.text = "\(meme.topText) \(meme.bottomText)" as String
        
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //1 - check delete operation
        if editingStyle == .Delete {
            //2 - modify the datasource
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            memes = appDelegate.memes
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        }
    }
    
    // MARK: TableView - Delegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Grab the DetailVC from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
        let detailVC = object as! MemeDetailViewController
        
        let meme = memes[indexPath.row]
        //Populate view controller with data from the selected item
        detailVC.meme = meme
        detailVC.memeIndex = indexPath.row
        
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
}
