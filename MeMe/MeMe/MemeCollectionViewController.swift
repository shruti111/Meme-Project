//
//  MemeCollectionViewController.swift
//  MeMe
//
//  Created by Shruti Choksi on 20/10/18.
//  Copyright (c) 2018 Shruti Choksi. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var sentMemes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemes = (UIApplication.shared.delegate as! AppDelegate).memes
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if  sentMemes.count == 0 {
            addNewMeme()
        }
    }
    
    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        addNewMeme()
    }
    func addNewMeme() {
        if let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewMemeEditorController") as? UINavigationController {
            present(memeViewController, animated: true, completion: nil)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sentMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell", for: indexPath) as! MemeCollectionViewCell
        let meme = sentMemes[indexPath.item]
        cell.setText(topString: meme.topString, bottomString: meme.bottomString)
        let imageView = UIImageView(image: meme.memeImage)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        cell.backgroundView = imageView
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeme = sentMemes[indexPath.row]
        performSegue(withIdentifier: "showDetailMemeFromCollectionView", sender: selectedMeme)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! MemeDetailViewController
        detailViewController.sentMeme = (sender as! Meme)
    }
}
