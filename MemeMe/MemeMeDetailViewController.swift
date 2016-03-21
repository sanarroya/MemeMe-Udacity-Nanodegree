//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by URpin on 3/20/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class MemeMeDetailViewController: UIViewController {

    @IBOutlet weak var originalImageMeme: UIImageView!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    
    var meme: Meme?
    var memeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    /**
     Initial configuration of the View, sets the the text attributes of the test fields and adds a right button to the navigation bar
     */
    private func configureView() {
        originalImageMeme.image = meme?.originalImage
        topLabel.text = meme?.topText
        topLabel.defaultTextAttributes = MemeMeAppearance.memeMeTextFieldTextAtribbutes()
        bottomLabel.text = meme?.bottomText
        bottomLabel.defaultTextAttributes = MemeMeAppearance.memeMeTextFieldTextAtribbutes()
        
        let editButton =  UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editMeme:"))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    
    /**
     Takes the user to the meme edition
     
     - parameter sender: Button that trigger the action
     */
    func editMeme(sender: AnyObject) {
        let editVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeMeEditViewController") as! MemeMeEditorViewController
        editVC.meme = meme
        editVC.hidesBottomBarWhenPushed = true
        presentViewController(editVC, animated: true, completion: nil)

    }
}