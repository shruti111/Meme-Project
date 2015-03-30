//
//  Meme.swift
//  MeMe
//
//  Created by Shruti Pawar on 14/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
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
