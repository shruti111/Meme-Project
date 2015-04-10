//
//  MemeTableViewController.swift
//  MeMe
//
//  Created by Shruti Pawar on 14/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var sentMemes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.leftBarButtonItem?.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sentMemes = (UIApplication.sharedApplication().delegate as AppDelegate).memes
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        setBarButtonState()
    }
    
    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        addNewMeme()
    }
    
    func addNewMeme() {
        var memeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewMemeEditorController") as UINavigationController
        self.presentViewController(memeViewController, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentMemes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableViewCell") as UITableViewCell
        let meme = sentMemes[indexPath.row]
        
        // If top and bottom texts are too long to display, display first few characters of top field and last few charactes of bottom filed
        var newStringForTopTextField =  countElements(meme.topString) > 7 ? (meme.topString as NSString).substringToIndex(6)  : meme.topString
        var newStringForBottomTextField =  countElements(meme.bottomString) > 7 ? (meme.bottomString as NSString).substringFromIndex(countElements(meme.bottomString) - 7) : meme.bottomString
        cell.textLabel?.text = newStringForTopTextField +  ".." + newStringForBottomTextField
        
        let itemSize  = CGSize(width: 88, height: 88)
        UIGraphicsBeginImageContext(itemSize);
        let imageRect = CGRect(x: 0, y: 0, width: 88, height: 88)
        
        meme.memeImage.drawInRect(imageRect)
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedMeme = sentMemes[indexPath.row]
        self.performSegueWithIdentifier("showDetailMeme", sender: selectedMeme)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            sentMemes.removeAtIndex(indexPath.row)
            (UIApplication.sharedApplication().delegate as AppDelegate).memes = sentMemes
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        setBarButtonState()
    }
    
    func setBarButtonState() {
            navigationItem.leftBarButtonItem?.enabled = sentMemes.count > 0 ? true : false
        if  sentMemes.count == 0 {
            addNewMeme()
        }
    }
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destinationViewController as MemeDetailViewController
        detailViewController.sentMeme = (sender as Meme)
    }
    
}
