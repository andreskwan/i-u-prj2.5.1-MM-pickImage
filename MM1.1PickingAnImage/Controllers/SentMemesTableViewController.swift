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
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
}
