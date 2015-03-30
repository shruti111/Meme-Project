//
//  MemeDetailViewController.swift
//  MeMe
//
//  Created by Shruti Pawar on 15/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    var sentMeme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memedImageView.image = sentMeme.memeImage
    }
    
    // Toggle tool bar and tab bar to show delete button
    override func viewWillAppear(animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
    }

   
    @IBAction func editMeme(sender: UIBarButtonItem){
        var memeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewMemeEditorController") as UINavigationController
        var topViewController = memeViewController.topViewController as MemeEditorViewController
        topViewController.editMeme = sentMeme
        self.presentViewController(memeViewController, animated: true, completion: nil)
    }

    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        var allMemes = (UIApplication.sharedApplication().delegate as AppDelegate).memes
        if let selectedMemeIndex = find(allMemes,sentMeme) {
            (UIApplication.sharedApplication().delegate as AppDelegate).memes.removeAtIndex(selectedMemeIndex)
        }

         self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
