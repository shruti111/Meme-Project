//
//  MemeCollectionViewController.swift
//  MeMe
//
//  Created by Shruti Pawar on 14/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var sentMemes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sentMemes = (UIApplication.sharedApplication().delegate as AppDelegate).memes
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if  sentMemes.count == 0 {
            addNewMeme()
        }
    }
    
    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        addNewMeme()
    }
    func addNewMeme() {
        var memeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewMemeEditorController") as UINavigationController
        self.presentViewController(memeViewController, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sentMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as MemeCollectionViewCell
        let meme = sentMemes[indexPath.item]
        cell.setText(meme.topString, bottomString: meme.bottomString)
        let imageView = UIImageView(image: meme.memeImage)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        cell.backgroundView = imageView
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var selectedMeme = sentMemes[indexPath.row]
        self.performSegueWithIdentifier("showDetailMemeFromCollectionView", sender: selectedMeme)
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destinationViewController as MemeDetailViewController
        detailViewController.sentMeme = (sender as Meme)
        
    }
    
}
