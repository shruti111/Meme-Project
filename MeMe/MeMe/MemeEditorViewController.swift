//
//  MemeEditorViewController.swift
//  MeMe
//
//  Created by Shruti Choksi on 20/10/18.
//  Copyright (c) 2018 Shruti Choksi. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // To check which text field is active (top or bottom)
    var activeTextField : UITextField!
    
    // To edit meme , use already saved meme object and update
    var editMeme : Meme? {
        didSet {
            if let bottomTextValue = editMeme?.bottomString  {
                bottomText = bottomTextValue
            }
            if let toptextValue = editMeme?.topString  {
                topText = toptextValue
            }
        }
    }
    
    var bottomText  = "BOTTOM"
    var topText = "TOP"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        let memeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.strokeWidth : -4.0,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!] as [NSAttributedString.Key : Any]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        topTextField.text = topText
        bottomTextField.text = bottomText
        if editMeme != nil {
            setStateOfUIControls(isNewMeme: false)
        } else {
            setStateOfUIControls(isNewMeme: true)
        }
           }
    
    func setStateOfUIControls(isNewMeme: Bool) {
        if isNewMeme {
            let navigationImageView = UIImageView(image: UIImage(named: "newMeme"))
            navigationItem.titleView = navigationImageView
        } else {
            imageView.image = editMeme?.originalImage
            title = "Edit Meme"
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = isNewMeme
        } else {
            cameraButton.isEnabled = false
        }
        albumButton.isEnabled = isNewMeme
        shareButton.isEnabled = !isNewMeme
        topTextField.isEnabled = !isNewMeme
        bottomTextField.isEnabled = !isNewMeme
        cancelButton.isEnabled = (UIApplication.shared.delegate as! AppDelegate).memes.count > 0 ? true : false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unSubscribeToKeyboardNotification()
    }
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unSubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        if activeTextField === bottomTextField {
            let keyBoardHeight : CGFloat = getKeyboardHeight(notification: notification)
             view.frame.origin.y -= keyBoardHeight
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
         if activeTextField === bottomTextField {
            self.view.frame.origin.y += getKeyboardHeight(notification: notification)
        }
    }
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func cancelMemeCreation(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPhotoAlbum(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func showCamera(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerController.SourceType.camera
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK:- UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
            topTextField.isEnabled = true
            bottomTextField.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
   
    //MARK:- UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if activeTextField === topTextField && textField.text == "TOP" {
            textField.text = ""
        }
        if activeTextField === bottomTextField && textField.text == "BOTTOM" {
            textField.text = ""
        }
 
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if activeTextField === topTextField && textField.text == "" {
            textField.text = "TOP"
        }
        if activeTextField === bottomTextField && textField.text == "" {
            textField.text = "BOTTOM"
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        activeTextField = nil
        return true
    }
    
    
    //MARK:- Save Meme
    
    func saveMemeObject() {
        let memeObject = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        if let meme = editMeme {
            let allMemes = (UIApplication.shared.delegate as! AppDelegate).memes
            if let selectedMemeIndex = allMemes.firstIndex(of: meme) {
                (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: selectedMemeIndex)
            }
        }
        // Update the meme collection to add or edit the meme object
        (UIApplication.shared.delegate as! AppDelegate).memes.append(memeObject)
        cancelButton.isEnabled = true
       
    }
    
    func generateMemedImage() -> UIImage {
        
        // Do not display navigation bar and tool bar

        self.navigationController?.navigationBar.isHidden = true
         self.navigationController?.toolbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        if let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.toolbar.isHidden = false
            return memedImage
        }
        return UIImage(named: "newMeme")!
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage =  generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities:nil)
        controller.completionWithItemsHandler = { activity,completed, items, error -> Void in

            if error != nil {
                print("There is an error while performing activity.")
            }
            
            // if user has completed the action , save meme object

            if completed  {
                self.saveMemeObject()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
    }


}
