//
//  MemeCollectionViewCell.swift
//  MeMe
//
//  Created by Shruti Choksi on 20/10/18.
//  Copyright (c) 2018 Shruti Choksi. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    
    func setText (topString : String! , bottomString:String!) {
        
        let memeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.strokeWidth : -3.0,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 22)!] as [NSAttributedString.Key : Any]
        
        topTextLabel.attributedText = NSAttributedString(string: topString, attributes: memeTextAttributes)
        bottomTextLabel.attributedText = NSAttributedString(string: bottomString, attributes: memeTextAttributes)
        topTextLabel.textAlignment = .center
        bottomTextLabel.textAlignment = .center
        
    }
    
}
