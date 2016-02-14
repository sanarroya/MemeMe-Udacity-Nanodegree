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
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var album: UIImagePickerController! = UIImagePickerController()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)){
            album.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            album.mediaTypes = [kUTTypeImage as String]
            self.presentViewController(album, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        album.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(album, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = ImageGeneration.generateMemedImage(containerView: memeContainer)
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true) {
            self.saveMeme(memedImage: memedImage)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if(picker.sourceType == .PhotoLibrary || picker.sourceType == .Camera){
            memeImageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: { Void in
            self.shareButton.enabled = true
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureView() {
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
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func saveMeme(memedImage memedImage: UIImage) {
        let newMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
    }
}

