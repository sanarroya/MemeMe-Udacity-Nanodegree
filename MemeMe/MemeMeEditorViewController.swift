//
//  ViewController.swift
//  MemeMe
//
//  Created by Santiago Avila on 12/26/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit
import MobileCoreServices

class MemeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var memeContainer: UIView!
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var canceButton: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var album: UIImagePickerController! = UIImagePickerController()
    var isEditingMeme = false
    var meme: Meme?
    var memeIndex: Int?
    var memeLoaded = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let meme = meme {
            if(!memeLoaded) {
                topTextField.text = meme.topText
                bottomTextField.text = meme.bottomText
                memeImageView.image = meme.originalImage
                memeImageView.contentMode = .ScaleAspectFit
                shareButton.enabled = true
                memeLoaded = true
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    /**
     Ends the edition or creation of a meme
     
     - parameter sender: Button that triggers the action
     */
    @IBAction func cancelMemeEdition(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Presents the gallery to the user, allowing the user to choose an image
     
     - parameter sender: Button that triggers the action
     */
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)){
            album.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            album.mediaTypes = [kUTTypeImage as String]
            presentViewController(album, animated: true, completion: nil)
        }
    }
    
    /**
     Presents the camera to the user
     
     - parameter sender: Button that triggers the action
     */
    @IBAction func takePhoto(sender: AnyObject) {
        album.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(album, animated: true, completion: nil)
    }
    
    /**
     Presents the user an activity view controller so he can share the meme
     
     - parameter sender: Button that triggers the action
     */
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = ImageGeneration.generateMemedImage(containerView: memeContainer)
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if(success){
                self.saveMeme(memedImage: memedImage)
                return
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    /**
     Sets the image selected by the user from the gallery or a photo taken to be edited
     
     - parameter picker:      Picker controller
     - parameter image:       Image chosen or photo taken
     - parameter editingInfo: Editinf info
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if(picker.sourceType == .PhotoLibrary || picker.sourceType == .Camera){
            memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: { Void in
            self.shareButton.enabled = true
        })
    }
    
    /**
     Gets call when the user cancels the selection of an image or closes the camera when taking a photo
     
     - parameter picker: Picker Controller
     */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Initial configuration of the view, set available types to the image picker controller, sets the default attributes of the textfields, subscribes the viewcontroller to keyboard notifications, hide the status bar and if the user is editing a meme sets the image, top and bottom texts to be edited
     */
    private func configureView() {
        album.delegate = self
        takePhotoButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        shareButton.enabled = false
        topTextField.defaultTextAttributes = MemeMeAppearance.memeMeTextFieldTextAtribbutes()
        topTextField.autocapitalizationType = .AllCharacters
        topTextField.delegate = self
        bottomTextField.defaultTextAttributes = MemeMeAppearance.memeMeTextFieldTextAtribbutes()
        bottomTextField.autocapitalizationType = .AllCharacters
        bottomTextField.delegate = self
        subscribeToKeyboardNotifications()
        self.prefersStatusBarHidden()
    }
    
    // MARK: Keyboard behaviour
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:" , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:" , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if(bottomTextField.isFirstResponder()) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    /**
     Saves or updates the meme into an array in the AppDelegate
     
     - parameter memedImage: meme image to save
     */
    private func saveMeme(memedImage memedImage: UIImage) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if(isEditingMeme) {
            appDelegate.memes[memeIndex!].memedImage = memedImage
            appDelegate.memes[memeIndex!].originalImage = memeImageView.image
            appDelegate.memes[memeIndex!].topText = topTextField.text!
            appDelegate.memes[memeIndex!].bottomText = bottomTextField.text!
            
        }else {
            let newMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
                        appDelegate.memes.append(newMeme)
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBarController")
        appDelegate.window?.rootViewController = tabBarController
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

