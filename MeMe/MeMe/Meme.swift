//
//  Meme.swift
//  MeMe
//
//  Created by Shruti Choksi on 20/10/18.
//  Copyright (c) 2018 Shruti Choksi. All rights reserved.
//

import Foundation
import UIKit


class Meme : NSObject {
    
    var topString : String!
    var bottomString: String!
    var originalImage : UIImage!
    var memeImage : UIImage!
    
    init(topText : String, bottomText:String, originalImage: UIImage, memedImage: UIImage) {
        self.topString = topText
        self.bottomString = bottomText
        self.originalImage = originalImage
        self.memeImage = memedImage
    }
    
}
