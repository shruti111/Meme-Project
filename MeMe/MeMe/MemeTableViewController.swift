//
//  MemeTableViewController.swift
//  MeMe
//
//  Created by Shruti Choksi on 24/10/18.
//  Copyright (c) 2015 Shruti Choksi. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var sentMemes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemes = (UIApplication.shared.delegate as! AppDelegate).memes
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setBarButtonState()
    }
    
    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        addNewMeme()
    }
    
    func addNewMeme() {
        if let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewMemeEditorController") as? UINavigationController {
            present(memeViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentMemes.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell")
        let meme = sentMemes[indexPath.row]
        
        // If top and bottom texts are too long to display, display first few characters of top field and last few charactes of bottom filed
        
        
        
        var newStringForTopTextField =  meme.topString.count > 7 ? (meme.topString as NSString).substring(to: 6)  : meme.topString
        var newStringForBottomTextField =  meme.bottomString.count > 7 ? (meme.bottomString as NSString).substring(from: meme.bottomString.count - 7) : meme.bottomString
        cell.textLabel?.text = newStringForTopTextField ?? "" +  ".." + newStringForBottomTextField ?? ""
        
        let itemSize  = CGSize(width: 88, height: 88)
        UIGraphicsBeginImageContext(itemSize);
        let imageRect = CGRect(x: 0, y: 0, width: 88, height: 88)
        
        meme.memeImage.draw(in: imageRect)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedMeme = sentMemes[indexPath.row]
        performSegue(withIdentifier: "showDetailMeme", sender: selectedMeme)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    // Override to support editing the table view.
    
    override  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
 {
        if editingStyle == .delete {
            sentMemes.remove(at: indexPath.row)
            (UIApplication.shared.delegate as! AppDelegate).memes = sentMemes
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        setBarButtonState()
    }
    
    func setBarButtonState() {
            navigationItem.leftBarButtonItem?.isEnabled = sentMemes.count > 0 ? true : false
        if  sentMemes.count == 0 {
            addNewMeme()
        }
    }
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? MemeDetailViewController {
            detailViewController.sentMeme = (sender as! Meme)
        }
    }
    
}
