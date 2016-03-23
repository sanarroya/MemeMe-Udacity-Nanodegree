//
//  MemeMeCollectionViewCell.swift
//  MemeMe
//
//  Created by URpin on 3/19/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class MemeMeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func configureCell(withMeme meme: Meme) {
        memeImageView.image = meme.originalImage
        topLabel.text = meme.topText
        bottomLabel.text = meme.bottomText
    }
}
