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
    
    
    @IBOutlet weak var memeContainer: UIView!
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var canceButton: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var album: UIImagePickerController! = UIImagePickerController()
    var isEditingMeme = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelMemeEdition(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)){
            album.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            album.mediaTypes = [kUTTypeImage as String]
            presentViewController(album, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        album.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(album, animated: true, completion: nil)
    }
    
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if(picker.sourceType == .PhotoLibrary || picker.sourceType == .Camera){
            memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: { Void in
            self.shareButton.enabled = true
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureView() {
        canceButton.enabled = isEditingMeme
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
    }
    
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
        if(bottomTextField.isFirstResponder()) {
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func saveMeme(memedImage memedImage: UIImage) {
        let newMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(newMeme)
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBarController")
        appDelegate.window?.rootViewController = tabBarController
    }
}

