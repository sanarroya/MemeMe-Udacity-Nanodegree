//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by URpin on 3/20/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var originalImageMeme: UIImageView!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureView() {
        originalImageMeme.image = meme?.originalImage
        topLabel.text = meme?.topText
        topLabel.defaultTextAttributes = MemeMeAppearance.memeMeTextFieldTextAtribbutes()
        bottomLabel.text = meme?.bottomText
        bottomLabel.defaultTextAttributes = MemeMeAppearance.memeMeTextFieldTextAtribbutes()
        
        let editButton =  UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editMeme:"))
        print(self.navigationController?.navigationItem.debugDescription)
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func editMeme(sender: AnyObject) {
        performSegueWithIdentifier("EditMeme", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EditMeme") {
            let editMemeViewController = segue.destinationViewController as! MemeMeEditorViewController
            editMemeViewController.hidesBottomBarWhenPushed = false
            editMemeViewController.meme = meme
        }
    }
}
