//
//  Meme.swift
//  MM1.1PickingAnImage
//
//  Created by Andres Kwan on 9/30/15.
//  Copyright © 2015 Kwan. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText: NSString!
    var bottomText: NSString!
    var image: UIImage!
    var memedImage: UIImage!
    
    init(topText:NSString, bottomText:NSString, image: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
