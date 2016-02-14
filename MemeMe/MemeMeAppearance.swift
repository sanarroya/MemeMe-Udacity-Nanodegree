//
//  MemeMeAppearance.swift
//  MemeMe
//
//  Created by Santiago Avila on 2/14/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeMeAppearance {
    
    class func memeMeTextFieldTextAtribbutes() -> [String: AnyObject] {
        guard let buttonFont = UIFont(name: "Impact", size: 40) else {
            return ["": ""]
        }
        let textParagraphStyle = NSMutableParagraphStyle()
        textParagraphStyle.alignment = .Center
        let memeTextAttributes = [
            NSParagraphStyleAttributeName: textParagraphStyle,
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: buttonFont,
            NSStrokeWidthAttributeName: -3.0
        ]
        
        return memeTextAttributes
    }
}