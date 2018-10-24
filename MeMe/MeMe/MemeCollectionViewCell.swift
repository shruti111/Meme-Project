//
//  MemeCollectionViewCell.swift
//  MeMe
//
//  Created by Shruti Pawar on 15/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    
    func setText (topString : String! , bottomString:String!) {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSStrokeWidthAttributeName : -3.0,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 22)!]
        
        topTextLabel.attributedText = NSAttributedString(string: topString, attributes: memeTextAttributes)
        bottomTextLabel.attributedText = NSAttributedString(string: bottomString, attributes: memeTextAttributes)
        topTextLabel.textAlignment = .center
        bottomTextLabel.textAlignment = .center
        
    }
    
}
