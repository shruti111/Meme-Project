//
//  MemeDetailViewController.swift
//  MeMe
//
//  Created by Shruti Choksi on 20/10/18.
//  Copyright (c) 2018 Shruti Choksi. All rights reserved.
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
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
    }

    
       @IBAction func editMeme(sender: UIBarButtonItem){
        if let memeViewController = storyboard?.instantiateViewController(withIdentifier: "NewMemeEditorController") as? UINavigationController {
            if let topViewController = memeViewController.topViewController as? MemeEditorViewController {
                topViewController.editMeme = sentMeme
                present(memeViewController, animated: true, completion: nil)
            }
        }
        
    }

    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        let allMemes = (UIApplication.shared.delegate as! AppDelegate).memes
        
        
        if let selectedMemeIndex = allMemes.firstIndex(of: sentMeme) {
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: selectedMemeIndex)            
        }

        self.navigationController?.popToRootViewController(animated: true)
    }
}
