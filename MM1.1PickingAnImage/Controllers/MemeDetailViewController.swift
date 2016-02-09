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
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        memeImage.image = image
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        super.viewWillDisappear(true)
    }
}
