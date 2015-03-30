//
//  MemeEditorViewController.swift
//  MeMe
//
//  Created by Shruti Pawar on 27/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
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
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -4.0,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        topTextField.text = topText
        bottomTextField.text = bottomText
        if let meme = editMeme {
            setStateOfUIControls(false)
        } else {
            setStateOfUIControls(true)
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
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
        cameraButton.enabled = isNewMeme
        } else {
            cameraButton.enabled = false
        }
        albumButton.enabled = isNewMeme
        shareButton.enabled = !isNewMeme
        topTextField.enabled = !isNewMeme
        bottomTextField.enabled = !isNewMeme
        
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unSubscribeToKeyboardNotification()
    }
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func unSubscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if activeTextField === bottomTextField {
        var keyBoardHeight : CGFloat = getKeyboardHeight(notification)
        self.view.frame.origin.y -= keyBoardHeight
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
         if activeTextField === bottomTextField {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func cancelMemeCreation(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showPhotoAlbum(sender: UIBarButtonItem) {
        var controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func showCamera(sender: UIBarButtonItem) {
        var controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK:- UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            shareButton.enabled = true
            topTextField.enabled = true
            bottomTextField.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        if activeTextField === topTextField && textField.text == "TOP" {
            textField.text = ""
        }
        if activeTextField === bottomTextField && textField.text == "BOTTOM" {
            textField.text = ""
        }
 
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if activeTextField === topTextField && textField.text == "" {
            textField.text = "TOP"
        }
        if activeTextField === bottomTextField && textField.text == "" {
            textField.text = "BOTTOM"
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        activeTextField = nil
        return true
    }
    
    
    //MARK:- Save Meme
    
    func saveMemeObject() {
        var memeObject = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        if let meme = editMeme {
            var allMemes = (UIApplication.sharedApplication().delegate as AppDelegate).memes
            if let selectedMemeIndex = find(allMemes,meme) {
                (UIApplication.sharedApplication().delegate as AppDelegate).memes.removeAtIndex(selectedMemeIndex)
            }
        }
        // Update the meme collection to add or edit the meme object
         (UIApplication.sharedApplication().delegate as AppDelegate).memes.append(memeObject)
       
    }
    
    func generateMemedImage() -> UIImage {
        
        // Do not display navigation bar and tool bar
        navigationController?.navigationBar.alpha = 0.0
        navigationController?.toolbar.alpha = 0.0
        view.backgroundColor = UIColor.whiteColor()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage =  generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities:nil)
        controller.completionWithItemsHandler = { activity,completed, items, error -> Void in

            if let error =  error {
                println("There is an error while performing activity.")
            }
            
            // if user has completed the action , save meme object
            // Else show navigation bar and toolbar
            if completed  {
                self.saveMemeObject()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.navigationController?.navigationBar.alpha = 1.0
                 self.navigationController?.toolbar.alpha = 1.0
            }
        }
        self.presentViewController(controller, animated: true, completion: nil)
    }


}
